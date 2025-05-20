import os

import ReactorKit
internal import RxSwift

public final class LoginReactor: Reactor {
    
    public enum Route {
        case none
        case termsAgreements
    }
    
    // MARK: - Reactor
    public enum Action {
        case kakaoLoginButtonTapped
        case appleLoginButtonTapped
        case guestLoginButtonTapped
    }
    
    public enum Mutation {
        case tryLogin
        case moveToTermsAgreementsScene
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
        case .kakaoLoginButtonTapped:
            os_log("kakaoLoginButtonTapped")
            return Observable.just(.tryLogin)
        case .appleLoginButtonTapped:
            os_log("appleLoginButtonTapped")
            return Observable.just(.tryLogin)
        case .guestLoginButtonTapped:
            return Observable.just(.moveToTermsAgreementsScene)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .tryLogin:
            break
        case .moveToTermsAgreementsScene:
            newState.route = .termsAgreements
        }
        
        return newState
    }
}
