import os

import Core
import DomainInterface

import ReactorKit
internal import RxSwift

public final class LoginReactor: Reactor {

    public enum Route {
        case none
        case termsAgreements
        case home
    }

    // MARK: - Reactor
    public enum Action {
        case kakaoLoginButtonTapped
        case appleLoginButtonTapped
        case guestLoginButtonTapped
    }

    public enum Mutation {
        case moveToHomeScene
        case moveToTermsAgreementsScene
    }

    public struct State {
        @Pulse var route: Route = .none
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()
    private let fetchAppleCredentialUseCase: FetchSocialCredentialUseCase
    private let fetchKakaoCredentialUseCase: FetchSocialCredentialUseCase
    private let loginWithAppleUseCase: LoginWithAppleUseCase
    private let loginWithKakaoUseCase: LoginWithKakaoUseCase

    // MARK: - init
    public init(
        fetchAppleCredentialUseCase: FetchSocialCredentialUseCase,
        fetchKakaoCredentialUseCase: FetchSocialCredentialUseCase,
        loginWithAppleUseCase: LoginWithAppleUseCase,
        loginWithKakaoUseCase: LoginWithKakaoUseCase
    ) {
        self.fetchAppleCredentialUseCase = fetchAppleCredentialUseCase
        self.fetchKakaoCredentialUseCase = fetchKakaoCredentialUseCase
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.loginWithKakaoUseCase = loginWithKakaoUseCase
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .kakaoLoginButtonTapped:
            return fetchKakaoCredentialUseCase.execute()
                .withUnretained(self)
                .flatMap { (owner, credential) in
                    return owner.loginWithKakaoUseCase.execute(credential: credential)
                }
                .map { response in
                    return response.isRegister ? .moveToHomeScene : .moveToTermsAgreementsScene
                }
        case .appleLoginButtonTapped:
            return fetchAppleCredentialUseCase.execute()
                .withUnretained(self)
                .flatMap { (owner, credential) in
                    return owner.loginWithAppleUseCase.execute(credential: credential)
                }
                .map { response in
                    return response.isRegister ? .moveToHomeScene : .moveToTermsAgreementsScene
                }
        case .guestLoginButtonTapped:
            return Observable.just(.moveToHomeScene)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .moveToHomeScene:
            newState.route = .home
        case .moveToTermsAgreementsScene:
            newState.route = .termsAgreements
        }
        return newState
    }
}
