import ReactorKit

import DomainInterface

public final class DictionaryMainReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case search
        case notification
        case login
    }

    public enum Action {
        case viewWillAppear
        case searchButtonTapped
        case notificationButtonTapped
    }

    public enum Mutation {
        case navigateTo(Route)
        case setLogin(Bool)
    }

    public struct State {
        @Pulse var route: Route = .none
        let type = DictionaryMainViewType.main
        var sections: [String] {
            return type.pageTabList.map { $0.title }
        }
        var isLogin = false
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    private let fetchProfileUseCase: FetchProfileUseCase

    // MARK: - init
    public init(fetchProfileUseCase: FetchProfileUseCase) {
        self.initialState = State()
        self.fetchProfileUseCase = fetchProfileUseCase
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return fetchProfileUseCase.execute()
                .map { .setLogin($0 != nil) }
        case .searchButtonTapped:
            return .just(.navigateTo(.search))
        case .notificationButtonTapped:
            return .just(.navigateTo(currentState.isLogin ? .notification : .login))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case let .setLogin(isLogin):
            newState.isLogin = isLogin
        }

        return newState
    }
}
