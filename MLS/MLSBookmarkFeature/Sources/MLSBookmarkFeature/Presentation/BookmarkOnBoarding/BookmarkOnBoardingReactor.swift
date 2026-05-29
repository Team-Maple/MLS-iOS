import ReactorKit
import RxSwift

final class BookmarkOnBoardingReactor: Reactor {
    enum Route {
        case none
        case dismiss
    }

    enum Action {
        case nextButtonTapped
        case backButtonTapped
    }

    enum Mutation {
        case setStep(BookmarkOnBoardingView.OnBoardingIndexType)
        case dismiss
    }

    struct State {
        @Pulse var route: Route = .none
        var step: BookmarkOnBoardingView.OnBoardingIndexType = .first
    }

    var initialState: State

    init() {
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .nextButtonTapped:
            let next = currentState.step.next()
            if next == .end {
                return .just(.dismiss)
            } else {
                return .just(.setStep(next))
            }
        case .backButtonTapped:
            return .just(.setStep(currentState.step.previous()))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
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
