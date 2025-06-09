import ReactorKit
import RxCocoa
import RxSwift

public final class NotificationReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case notificationAlert
    }

    public enum Action {
        case nextButtonTapped
    }

    public enum Mutation {
        case navigateTo(route: Route)
    }

    public struct State {
        @Pulse var route: Route = .none
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    // MARK: - init
    public init() {
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .nextButtonTapped:
            return Observable.just(.navigateTo(route: .notificationAlert))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        }

        return newState
    }
}
