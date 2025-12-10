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
        case changeTab(Int)
    }

    public enum Mutation {
        case navigateTo(Route)
        case setLogin(Bool)
        case setCurrentTab(oldIndex: Int, newIndex: Int)
    }

    public struct State {
        @Pulse var route: Route = .none
        let type = DictionaryMainViewType.main
        var sections: [String] {
            return type.pageTabList.map { $0.title }
        }
        var isLogin = false
        var currentPageIndex = 0
        var oldPageIndex = 0
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
                .catchAndReturn(.setLogin(false))
        case .searchButtonTapped:
            return .just(.navigateTo(.search))
        case .notificationButtonTapped:
            return .just(.navigateTo(currentState.isLogin ? .notification : .login))
        case let .changeTab(index):
            let oldIndex = currentState.currentPageIndex
            return .just(.setCurrentTab(oldIndex: oldIndex, newIndex: index))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case let .setLogin(isLogin):
            newState.isLogin = isLogin
        case let .setCurrentTab(oldIndex, newIndex):
            newState.oldPageIndex = oldIndex
            newState.currentPageIndex = newIndex
        }

        return newState
    }
}
