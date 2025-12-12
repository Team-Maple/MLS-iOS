import DomainInterface

import ReactorKit

public final class DetailOnBoardingReactor: Reactor {
    // MARK: - Route
    public enum Route {
        case none
        case dismiss
    }

    // MARK: - Action
    public enum Action {
        case closeButtonTapped
    }

    // MARK: - Mutation
    public enum Mutation {
        case toNavigate(Route)
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route = .none
    }

    public var initialState: State
    private let disposeBag = DisposeBag()

    // MARK: - Init
    public init() {
        self.initialState = State(route: .none)
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .closeButtonTapped:
            .just(.toNavigate(.dismiss))
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .toNavigate(route):
            newState.route = route
        }
        return newState
    }
}
