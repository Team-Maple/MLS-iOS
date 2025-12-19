import DomainInterface
import ReactorKit
import RxSwift

public final class DictionaryNotificationReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case setting
        case notification(url: String)
    }

    public enum Action {
        case viewWillAppear
        case loadMore
        case backButtonTapped
        case settingButtonTapped
        case notificationTapped(index: Int)
    }

    public enum Mutation {
        case setNotifications([AllAlarmResponse], hasMore: Bool, reset: Bool)
        case setLoading(Bool)
        case setProfile(MyPageResponse?)
        case navigateTo(Route)
        case setPermission(Bool)
        case checkAlarm(link: String)
    }

    public struct State {
        @Pulse var route: Route = .none
        var notifications: [AllAlarmResponse] = []
        var profile: MyPageResponse?
        var hasMore: Bool = false
        var isLoading: Bool = false
        var permission = false
    }

    // MARK: - Properties
    public var initialState: State
    private let disposeBag = DisposeBag()
    private let fetchAllAlarmUseCase: FetchAllAlarmUseCase
    private let fetchProfileUseCase: FetchProfileUseCase
    private let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
    private let setReadUseCase: SetReadUseCase

    // MARK: - Init
    public init(fetchAllAlarmUseCase: FetchAllAlarmUseCase, fetchProfileUseCase: FetchProfileUseCase, checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase, setReadUseCase: SetReadUseCase) {
        self.initialState = State()
        self.fetchAllAlarmUseCase = fetchAllAlarmUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
        self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
        self.setReadUseCase = setReadUseCase
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let profileStream: Observable<Mutation> = fetchProfileUseCase.execute()
                .map { Mutation.setProfile($0) }

            let notificationStream: Observable<Mutation> = Observable.concat([
                Observable<Mutation>.just(.setLoading(true)),
                fetchAllAlarmUseCase.execute(cursor: nil, pageSize: 20)
                    .map { paged in
                        Mutation.setNotifications(paged.items, hasMore: paged.hasMore, reset: true)
                    },
                Observable<Mutation>.just(.setLoading(false))
            ])

            let permissionStream: Observable<Mutation> = checkNotificationPermissionUseCase.execute()
                .asObservable()
                .map { Mutation.setPermission($0) }

            return Observable.merge(profileStream, notificationStream, permissionStream)

        case .loadMore:
            guard currentState.hasMore, !currentState.isLoading else { return .empty() }
            let cursor = currentState.notifications.last?.date

            return Observable.concat([
                Observable<Mutation>.just(.setLoading(true)),
                fetchAllAlarmUseCase.execute(cursor: cursor, pageSize: 20)
                    .map { paged in
                        Mutation.setNotifications(paged.items, hasMore: paged.hasMore, reset: false)
                    },
                Observable<Mutation>.just(.setLoading(false))
            ])

        case .backButtonTapped:
            return .just(.navigateTo(.dismiss))

        case .settingButtonTapped:
            return .just(.navigateTo(.setting))

        case let .notificationTapped(index):
            let notification = currentState.notifications[index]

            return setReadUseCase.execute(alarmLink: notification.link)
                .andThen(
                    Observable.concat([
                        .just(.checkAlarm(link: notification.link)),
                        .just(.navigateTo(.notification(url: notification.link)))
                    ])
                )
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setNotifications(newItems, hasMore, reset):
            if reset {
                newState.notifications = newItems
            } else {
                newState.notifications.append(contentsOf: newItems)
            }
            newState.hasMore = hasMore

        case let .setLoading(isLoading):
            newState.isLoading = isLoading

        case let .setProfile(profile):
            newState.profile = profile

        case let .navigateTo(route):
            newState.route = route

        case let .setPermission(granted):
            newState.permission = granted
        case let .checkAlarm(link):
            if let index = newState.notifications.firstIndex(where: { $0.link == link }) {
                newState.notifications[index].alreadyRead = true
            }
        }

        return newState
    }
}
