import DomainInterface

import ReactorKit

public final class BookmarkMainReactor: Reactor {
    public enum Route {
        case none
        case search
        case onBoarding
        case notification
        case edit
        case login
    }

    public enum Action {
        case viewWillAppear
        case searchButtonTapped
        case notificationButtonTapped
        case loginButtonTapped
    }

    public enum Mutation {
        case navigateTo(Route)
        case setLogin(Bool)
    }

    public struct State {
        @Pulse var route: Route
        let type = DictionaryMainViewType.bookmark
        var sections: [String] {
            return type.pageTabList.map { $0.title }
        }

        var isLogin = false
    }

    // MARK: - Properties
    private let setBookmarkUseCase: SetBookmarkUseCase
    private let checkLoginUseCase: CheckLoginUseCase
    private let fetchVisitBookmarkUseCase: FetchVisitBookmarkUseCase

    public var initialState: State

    private let disposeBag = DisposeBag()

    public init(setBookmarkUseCase: SetBookmarkUseCase, checkLoginUseCase: CheckLoginUseCase, fetchVisitBookmarkUseCase: FetchVisitBookmarkUseCase) {
        self.initialState = State(route: .none)
        self.setBookmarkUseCase = setBookmarkUseCase
        self.checkLoginUseCase = checkLoginUseCase
        self.fetchVisitBookmarkUseCase = fetchVisitBookmarkUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let onboardingMutation = fetchVisitBookmarkUseCase.execute()
                .flatMap { hasVisited -> Observable<Mutation> in
                    if hasVisited {
                        return .empty()
                    } else {
                        return .just(.navigateTo(.onBoarding))
                    }
                }
            let loginMutation = checkLoginUseCase.execute()
                .map { Mutation.setLogin($0) }
            return .concat([onboardingMutation, loginMutation])
        case .searchButtonTapped:
            return Observable.just(.navigateTo(.search))
        case .notificationButtonTapped:
            return Observable.just(.navigateTo(.notification))
        case .loginButtonTapped:
            return .just(.navigateTo(.login))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .navigateTo(route):
            newState.route = route
        case let .setLogin(isLogin):
            newState.isLogin = isLogin
        }
        return newState
    }
}
