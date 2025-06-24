import ReactorKit

import DomainInterface

public final class DictionarySearchResultReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
    }

    public enum Action {
        case backbuttonTapped
        case updateKeyword(String)
    }

    public enum Mutation {
        case navigateTo(Route)
        case setKeyword(String)
    }

    public struct State {
        @Pulse var route: Route = .none
        var sections = DictionaryType.allCases.map { $0.title }
        var keyword: String?
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    // MARK: - init
    public init(keyword: String?) {
        self.initialState = State(keyword: keyword)
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backbuttonTapped:
            return Observable.just(.navigateTo(.dismiss))
        case .updateKeyword(let keyword):
            return Observable.just(.setKeyword(keyword))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .setKeyword(let keyword):
            newState.keyword = keyword

        }

        return newState
    }
}
