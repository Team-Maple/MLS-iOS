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

    private let checkLoginUseCase: CheckLoginUseCase

    // MARK: - init
    public init(checkLoginUseCase: CheckLoginUseCase) {
        self.initialState = State()
        self.checkLoginUseCase = checkLoginUseCase
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchButtonTapped:
            return Observable.just(.navigateTo(.search))
        case .notificationButtonTapped:
            return checkLoginUseCase.execute()
                .map { isLogin in
                    if isLogin {
                        return .navigateTo(.notification)
                    } else {
                        return .navigateTo(.login)
                    }
                }
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
