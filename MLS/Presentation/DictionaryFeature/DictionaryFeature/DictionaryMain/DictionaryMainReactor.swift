import ReactorKit

import DomainInterface

public final class DictionaryMainReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case search
        case notification
    }

    public enum Action {
        case searchButtonTapped
        case notificationButtonTapped
    }

    public enum Mutation {
        case navigateTo(Route)
    }

    public struct State {
        @Pulse var route: Route = .none
        let type = DictionaryMainViewType.main
        var sections: [String] {
            return type.pageTabList.map { $0.title }
        }
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
        case .searchButtonTapped:
            return Observable.just(.navigateTo(.search))
        case .notificationButtonTapped:
            return Observable.just(.navigateTo(.notification))
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
