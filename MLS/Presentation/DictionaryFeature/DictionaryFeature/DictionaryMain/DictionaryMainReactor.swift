import ReactorKit

import DomainInterface

public final class DictionaryMainReactor: Reactor {
    // MARK: - Reactor
    public enum DictionaryListType {
        case main
        case searchResult
    }

    public enum Route {
        case none
        case search
    }

    public enum Action {
        case searchButtonTapped
    }

    public enum Mutation {
        case navigateTo(Route)
    }

    public struct State {
        @Pulse var route: Route = .none
        var type: DictionaryListType
        var sections = DictionaryType.allCases.map { $0.title }
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    // MARK: - init
    public init(type: DictionaryListType) {
        self.initialState = State(type: type)
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchButtonTapped:
            return Observable.just(.navigateTo(.search))
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
