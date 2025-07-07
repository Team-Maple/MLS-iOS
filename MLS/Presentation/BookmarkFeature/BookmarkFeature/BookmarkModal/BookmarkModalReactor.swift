import DesignSystem
import DomainInterface

import ReactorKit

public final class BookmarkModalReactor: Reactor {
    public enum Route {
        case none
        case dismiss
    }

    public enum Action {
        case backButtonTapped
    }

    public enum Mutation {
        case toNavigate(Route)

    }

    public struct State {
        @Pulse var route: Route
        
        var collections = ["1", "2", "3", "4", "5"]
    }

    public var initialState: State
    
    private let disposeBag = DisposeBag()

    public init() {
        self.initialState = State(route: .none)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return Observable.just(.toNavigate(.dismiss))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .toNavigate(let route):
            newState.route = route
        }
        return newState
    }
}
