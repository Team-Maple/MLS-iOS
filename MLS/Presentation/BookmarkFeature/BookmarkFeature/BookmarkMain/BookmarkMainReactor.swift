import DesignSystem
import DomainInterface

import ReactorKit

public final class BookmarkMainReactor: Reactor {
    public enum Route {
        case none
        case onBoarding
    }

    public enum Action {
        case viewDidAppear
        case dismissOnboarding
    }

    public enum Mutation {
        case presentOnboarding
    }

    public struct State {
        @Pulse var route: Route
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
                return .just(.presentOnboarding)
            }

        case .dismissOnboarding:
            setOnBoardingUseCase.execute()
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .presentOnboarding:
            newState.route = .onBoarding
        }
        return newState
    }
}
