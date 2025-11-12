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
    }

    public struct State {
        @Pulse var route: Route = .none
        var notifications: [AllAlarmResponse] = []
        var profile: MyPageResponse?
        var hasMore: Bool = false
        var isLoading: Bool = false
    }

    // MARK: - Properties
    public var initialState: State
    private let disposeBag = DisposeBag()
    private let fetchAllAlarmUseCase: FetchAllAlarmUseCase
    private let fetchProfileUseCase: FetchProfileUseCase

    // MARK: - Init
    public init(fetchAllAlarmUseCase: FetchAllAlarmUseCase, fetchProfileUseCase: FetchProfileUseCase) {
        self.initialState = State()
        self.fetchAllAlarmUseCase = fetchAllAlarmUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .concat([
                .just(.setLoading(true)),
                fetchAllAlarmUseCase.execute(cursor: nil, pageSize: 20)
                    .map { paged in
                        .setNotifications(paged.items, hasMore: paged.hasMore, reset: true)
                    },
                .just(.setLoading(false))
            ])
        case .loadMore:
            guard currentState.hasMore, !currentState.isLoading else { return .empty() }
            let cursor = currentState.notifications.last?.date

            return .concat([
                .just(.setLoading(true)),
                fetchAllAlarmUseCase.execute(cursor: cursor, pageSize: 20)
                    .map { paged in
                        .setNotifications(paged.items, hasMore: paged.hasMore, reset: false)
                    },
                .just(.setLoading(false))
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
        }

        return newState
    }
}
