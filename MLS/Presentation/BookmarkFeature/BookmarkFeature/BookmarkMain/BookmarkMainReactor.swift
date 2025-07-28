import DesignSystem
import DomainInterface

import ReactorKit

public final class BookmarkMainReactor: Reactor {
    public enum Route {
        case none
        case search
        case onBoarding
        case notification
    }

    public enum Action {
        case viewDidAppear
        case dismissOnboarding
        case searchButtonTapped
        case notificationButtonTapped
    }

    public enum Mutation {
        case navigateTo(Route)
    }

    public struct State {
        @Pulse var route: Route
        let type = DictionaryMainViewType.bookmark
        var sections: [String] {
            return type.pageTabList.map { $0.title }
        }
    }

    // MARK: - Properties
    private let getOnBoardingUseCase: GetBookmarkOnboardingUseCase
    private let setOnBoardingUseCase: SetBookmarkOnBoardingUseCase

    public var initialState: State

    private let disposeBag = DisposeBag()

    public init(getOnBoardingUseCase: GetBookmarkOnboardingUseCase, setOnBoardingUseCase: SetBookmarkOnBoardingUseCase) {
        self.initialState = State(route: .none)
        self.getOnBoardingUseCase = getOnBoardingUseCase
        self.setOnBoardingUseCase = setOnBoardingUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidAppear:
            if getOnBoardingUseCase.execute() {
                return .empty()
            } else {
                return .just(.navigateTo(.onBoarding))
            }

        case .dismissOnboarding:
            setOnBoardingUseCase.execute()
            return .empty()
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
