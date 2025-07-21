import DesignSystem
import DomainInterface

import ReactorKit

public final class BookmarkModalReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case addCollection
    }

    public enum Action {
        case backButtonTapped
        case addCollectionTapped
    }

    public enum Mutation {
        case toNavigate(Route)
    }

    public struct State {
        @Pulse var route: Route
        var collections = ["1", "2", "3"]
    }

    public var initialState: State

    private let disposeBag = DisposeBag()

    public init() {
        self.initialState = State(route: .none)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.toNavigate(.dismiss))
        case .addCollectionTapped:
            return .just(.toNavigate(.addCollection))
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
