import ReactorKit

import DomainInterface

public final class DictionaryNotificationReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case setting
        case notification(String)
    }

    public enum Action {
        case backbuttonTapped
        case settingButtonTapped
        case notificationTapped(String)
        case viewWillAppear
    }

    public enum Mutation {
        case navigateTo(Route)
        case setNotifications([Notification])
    }

    public struct State {
        @Pulse var route: Route = .none
        var notifications: [Notification] = []
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    private let fetchNotificationUseCase: FetchNotificationUseCase

    // MARK: - init
    public init(fetchNotificationUseCase: FetchNotificationUseCase) {
        self.initialState = State()
        self.fetchNotificationUseCase = fetchNotificationUseCase
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backbuttonTapped:
            return Observable.just(.navigateTo(.dismiss))
        case .settingButtonTapped:
            return Observable.just(.navigateTo(.setting))
        case .notificationTapped(let notification):
            return Observable.just(.navigateTo(.notification(notification)))
        case .viewWillAppear:
            return fetchNotificationUseCase.execute()
                .map { Mutation.setNotifications($0) }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .setNotifications(let notifications):
            newState.notifications = notifications
        }

        return newState
    }
}
