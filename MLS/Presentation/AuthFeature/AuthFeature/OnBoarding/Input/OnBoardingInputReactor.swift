import ReactorKit
internal import RxSwift
internal import RxCocoa

public final class OnBoardingInputReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case home
        case notification
    }
    
    public enum Action {
        case backButtonTapped
        case inputLevel(Int?)
        case inputRole(String?)
        case cancelOnBoarding
        case nextButtonTapped
    }
    
    public enum Mutation {
        case moveToPreScene
        case changeLevel(Int?)
        case changeRole(String?)
        case moveToHomeScene
        case moveToNextScene
    }
    
    public struct State {
        @Pulse var route: Route = .none
        
        var level: Int? = nil
        var role: String? = nil
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
        case .inputLevel(let level):
            return Observable.just(.changeLevel(level))
        case .inputRole(let role):
            return Observable.just(.changeRole(role))
        case .cancelOnBoarding:
            return Observable.just(.moveToHomeScene)
        case .nextButtonTapped:
            return Observable.just(.moveToNextScene)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .moveToPreScene:
            newState.route = .dismiss
        case .changeLevel(let level):
            newState.level = level
        case .changeRole(let role):
            newState.role = role
        case .moveToHomeScene:
            newState.route = .home
        case .moveToNextScene:
            newState.route = .notification
        }
        
        return newState
    }
}
