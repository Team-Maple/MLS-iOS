import MLSBookmarkFeatureInterface
import ReactorKit
import RxSwift

final class BookmarkMainReactor: Reactor {
    enum Route {
        case none
        case search
        case onBoarding
        case notification
        case edit
        case login
    }

    enum Action {
        case viewWillAppear
        case searchButtonTapped
        case notificationButtonTapped
        case loginButtonTapped
    }

    enum Mutation {
        case navigateTo(Route)
        case setLogin(Bool)
    }

    struct State {
        @Pulse var route: Route
        let type = DictionaryMainViewType.bookmark
        var sections: [String] {
            return type.pageTabList.map { $0.title }
        }
        var isLogin = false
    }

    var initialState: State

    private let authRepository: BookmarkAuthRepository
    private let userDefaultsRepository: BookmarkUserDefaultsRepository

    init(authRepository: BookmarkAuthRepository, userDefaultsRepository: BookmarkUserDefaultsRepository) {
        self.initialState = State(route: .none)
        self.authRepository = authRepository
        self.userDefaultsRepository = userDefaultsRepository
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let onboardingMutation = userDefaultsRepository.hasVisitedOnboarding()
                .flatMap { hasVisited -> Observable<Mutation> in
                    if hasVisited { return .empty() } else { return .just(.navigateTo(.onBoarding)) }
                }
            let loginMutation = authRepository.isLoggedIn().map { Mutation.setLogin($0) }
            return .concat([onboardingMutation, loginMutation])
        case .searchButtonTapped:
            return .just(.navigateTo(.search))
        case .notificationButtonTapped:
            return .just(.navigateTo(.notification))
        case .loginButtonTapped:
            return .just(.navigateTo(.login))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
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
