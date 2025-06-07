import ReactorKit
import RxCocoa
import RxSwift

public final class OnBoardingNotificationReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case home
        case modal
    }

    public enum Action {
        case backButtonTapped
        case nextButtonTapped
        case cancelOnBoarding
    }

    public enum Mutation {
        case moveToPreScene
        case moveToHomeScene
        case showModal
    }

    public struct State {
        @Pulse var route: Route = .none
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
        case .backButtonTapped:
            return Observable.just(.moveToPreScene)
        case .nextButtonTapped:
            return Observable.just(.showModal)
        case .cancelOnBoarding:
            return Observable.just(.moveToHomeScene)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .moveToPreScene:
            newState.route = .dismiss
        case .moveToHomeScene:
            newState.route = .home
        case .showModal:
            newState.route = .modal
        }

        return newState
    }
}
