import ReactorKit
internal import RxCocoa
internal import RxSwift

public final class OnBoardingModalReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
    }

    public enum Action {
        case agreeButtonTapped
        case disagreeButtonTapped
    }

    public enum Mutation {
        case showPermission
        case moveToPreScene
    }

    public struct State {
        @Pulse var route: Route = .none

        var isAgreeNotification: Bool = false
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
        case .agreeButtonTapped:
            return Observable.just(.showPermission)
        case .disagreeButtonTapped:
            return Observable.just(.moveToPreScene)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .showPermission:
            // 권한 설정
//            newState.isAgreeNotification = true
            newState.isAgreeNotification = false
            newState.route = .dismiss
        case .moveToPreScene:
            newState.route = .dismiss
        }

        return newState
    }
}
