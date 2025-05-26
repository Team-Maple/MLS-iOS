import ReactorKit
internal import RxSwift
internal import RxCocoa

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
        case agreeButtonTapped
        case disagreeButtonTapped
        case cancelOnBoarding
    }
    
    public enum Mutation {
        case moveToPreScene
        case moveToHomeScene
        case showModalAndCompleteOnBoarding
        case agreeNotification
        case disagreeNotification
    }
    
    public struct State {
        @Pulse var route: Route = .none
        
        var isCheckNotification: Bool = false
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
            return Observable.just(.showModalAndCompleteOnBoarding)
        case .agreeButtonTapped:
            return Observable.just(.agreeNotification)
        case .disagreeButtonTapped:
            return Observable.just(.disagreeNotification)
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
        case .showModalAndCompleteOnBoarding:
            if newState.isCheckNotification {
                // 정보 저장
                newState.route = .home
            } else {
                newState.route = .modal
            }
        case .agreeNotification:
            // 알람 설정 띄우기
            newState.isCheckNotification = true
        case .disagreeNotification:
            newState.isCheckNotification = true
        }
        
        return newState
    }
}
