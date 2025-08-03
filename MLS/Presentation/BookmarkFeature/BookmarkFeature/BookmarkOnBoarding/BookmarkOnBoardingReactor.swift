import ReactorKit

public final class BookmarkOnBoardingReactor: Reactor {
    public enum Route {
        case none
        case dismiss
    }

    public enum Action {
        case nextButtonTapped
        case backButtonTapped
    }

    public enum Mutation {
        case setStep(BookmarkOnBoardingView.OnBoardingIndexType)
        case dismiss
    }

    public struct State {
        @Pulse var route: Route = .none
        var step: BookmarkOnBoardingView.OnBoardingIndexType = .first
    }

    public var initialState: State

    private let disposeBag = DisposeBag()

    public init() {
        self.initialState = State()
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .nextButtonTapped:
            let next = currentState.step.next()
            if next == .end {
                return .just(.dismiss)
            } else {
                return .just(.setStep(next))
            }

        case .backButtonTapped:
            let prev = currentState.step.previous()
            return .just(.setStep(prev))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setStep(let step):
            newState.step = step
        case .dismiss:
            newState.route = .dismiss
        }
        return newState
    }
}
