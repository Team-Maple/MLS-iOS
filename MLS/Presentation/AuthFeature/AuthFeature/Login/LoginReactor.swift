import os

import Core
import DomainInterface

import ReactorKit
internal import RxSwift

public final class LoginReactor: Reactor {

    public enum Route {
        case none
        case termsAgreements(credential: Encodable, platform: LoginPlatform)
        case home
        case error
    }

    // MARK: - Reactor
    public enum Action {
        case kakaoLoginButtonTapped
        case appleLoginButtonTapped
        case guestLoginButtonTapped
    }

    public enum Mutation {
        case moveToHomeScene
        case moveToTermsAgreementsScene(credential: Encodable, platform: LoginPlatform)
        case moveToErrorScene
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
                    return owner.loginWithKakaoUseCase.execute(credential: credential).map { (response: $0, credential: credential) }
                }
                .map { result in
                    return result.response.isRegister ? .moveToHomeScene : .moveToTermsAgreementsScene(credential: result.credential, platform: .kakao)
                }
                .catch { error in
                    return Observable.just(.moveToErrorScene)
                }
        case .appleLoginButtonTapped:
            return fetchAppleCredentialUseCase.execute()
                .withUnretained(self)
                .flatMap { (owner, credential) in
                    return owner.loginWithAppleUseCase.execute(credential: credential).map { (response: $0, credential: credential) }
                }
                .map { result in
                    return result.response.isRegister ? .moveToHomeScene : .moveToTermsAgreementsScene(credential: result.credential, platform: .apple)
                }
                .catch { error in
                    return Observable.just(.moveToErrorScene)
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
        case .moveToTermsAgreementsScene(let credential, let platform):
            newState.route = .termsAgreements(credential: credential, platform: platform)
        case .moveToErrorScene:
            newState.route = .error
        }
        return newState
    }
}
