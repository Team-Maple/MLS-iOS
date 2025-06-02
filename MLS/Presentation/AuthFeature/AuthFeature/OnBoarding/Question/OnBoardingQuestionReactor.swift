import ReactorKit
internal import RxCocoa
internal import RxSwift

public final class OnBoardingQuestionReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case home
        case input
    }

    public enum Action {
        case enterScene
        case nextButtonTapped
        case backButtonTapped
        case cancelOnBoarding
    }

    public enum Mutation {
        case showToast
        case moveToInputScene
        case moveToPreScene
        case moveToHomeScene
    }

    public struct State {
        @Pulse var route: Route = .none
        @Pulse var isShowToast: Bool = false
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
        case .enterScene:
            return Observable.just(.showToast)
        case .nextButtonTapped:
            return Observable.just(.moveToInputScene)
        case .backButtonTapped:
            return Observable.just(.moveToPreScene)
        case .cancelOnBoarding:
            return Observable.just(.moveToHomeScene)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .showToast:
            newState.isShowToast.toggle()
        case .moveToInputScene:
            newState.route = .input
        case .moveToPreScene:
            newState.route = .dismiss
        case .moveToHomeScene:
            newState.route = .home
        }

        return newState
    }
}
