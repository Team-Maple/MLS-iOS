import ReactorKit

public final class SetProfileReactor: Reactor {
    // MARK: - Route
    public enum Route {
        
    }

    // MARK: - Action
    public enum Action {
        
    }

    // MARK: - Mutation
    public enum Mutation {
        case toNavigate(Route)
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route?
        var setProfileState: SetProfileView.SetProfileState
    }

    // MARK: - Properties
    public var initialState = State(setProfileState: .normal)

    // MARK: - Init
    public init() {
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .toNavigate(let route):
            newState.route = route
        }

        return newState
    }
}
