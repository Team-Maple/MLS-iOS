import os

import Core
import DomainInterface

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
    private let appleLoginUseCase: SocialLoginUseCase
    private let kakaoLoginUseCase: SocialLoginUseCase
    private let loginWithAppleUseCase: LoginWithAppleUseCase
    private let loginWithKakaoUseCase: LoginWithKakaoUseCase

    // MARK: - init
    public init(
        appleLoginUseCase: SocialLoginUseCase,
        kakaoLoginUseCase: SocialLoginUseCase,
        loginWithAppleUseCase: LoginWithAppleUseCase,
        loginWithKakaoUseCase: LoginWithKakaoUseCase
    ) {
        self.appleLoginUseCase = appleLoginUseCase
        self.kakaoLoginUseCase = kakaoLoginUseCase
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.loginWithKakaoUseCase = loginWithKakaoUseCase
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .kakaoLoginButtonTapped:
            os_log("kakaoLoginButtonTapped")
            return kakaoLoginUseCase.execute()
                .map { credential in
                    print(credential)
                    return .tryLogin
                }
        case .appleLoginButtonTapped:
            return appleLoginUseCase.execute()
                .map { credential in
                    print(credential)
                    return .tryLogin
                }
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
