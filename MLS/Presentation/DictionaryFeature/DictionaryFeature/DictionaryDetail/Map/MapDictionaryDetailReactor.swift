import DomainInterface

import ReactorKit

public final class MapDictionaryDetailReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case filter(DictionaryType)
    }
    public enum Action {
        case filterButtonTapped
    }

    public enum Mutation {
        case showFilter
    }

    public struct State {
        @Pulse var route: Route = .none
        var type: DictionaryType = .map
    }

    public var initialState: State
    private let disposBag = DisposeBag()

    public init() {
        initialState = State(type: .map)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .filterButtonTapped:
            return Observable.just(.showFilter)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .showFilter:
            newState.route = .filter(newState.type)
        }
        return newState
    }
}
