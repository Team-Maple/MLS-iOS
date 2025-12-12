import DomainInterface
import ReactorKit
import RxSwift

public final class DictionaryNotificationReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case setting
        case notification(String)
    }

    public enum Action {
        case viewWillAppear
        case loadMore
        case backButtonTapped
        case settingButtonTapped
        case notificationTapped(String)
    }

    public enum Mutation {
        case setNotifications([AllAlarmResponse], hasMore: Bool, reset: Bool)
        case setLoading(Bool)
        case setProfile(MyPageResponse?)
        case navigateTo(Route)
        case setPermission(Bool)
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

    // MARK: - Init
    public init(fetchAllAlarmUseCase: FetchAllAlarmUseCase, fetchProfileUseCase: FetchProfileUseCase, checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase) {
        self.initialState = State()
        self.fetchAllAlarmUseCase = fetchAllAlarmUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
        self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
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

        case .notificationTapped(let notification):
            return .just(.navigateTo(.notification(notification)))
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
        }

        return newState
    }
}
