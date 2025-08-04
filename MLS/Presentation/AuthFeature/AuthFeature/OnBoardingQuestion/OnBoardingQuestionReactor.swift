import ReactorKit
import RxSwift

public final class OnBoardingQuestionReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case home
        case input
    }

    public enum Action {
        case viewDidLoad
        case nextButtonTapped
        case backButtonTapped
        case skipButtonTapped
    }

    public enum Mutation {
        case showToast
        case navigateTo(route: Route)
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
        case .viewDidLoad:
            return Observable.just(.showToast)
        case .nextButtonTapped:
            return Observable.just(.navigateTo(route: .input))
        case .backButtonTapped:
            return Observable.just(.navigateTo(route: .dismiss))
        case .skipButtonTapped:
            return Observable.just(.navigateTo(route: .home))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .showToast:
            newState.isShowToast.toggle()
        case .navigateTo(let route):
            newState.route = route
        }

        return newState
    }
}
