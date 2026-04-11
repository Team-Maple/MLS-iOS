import MLSAuthFeatureInterface
import MLSCore

import RxSwift

public struct LoginFactoryImpl: LoginFactory {
    private let termsAgreementsFactory: TermsAgreementFactory
    private let appleProvider: SocialAuthenticatableProvider
    private let kakaoProvider: SocialAuthenticatableProvider
    private let loginWithAppleUseCase: LoginWithAppleUseCase
    private let loginWithKakaoUseCase: LoginWithKakaoUseCase
    private let tokenRepository: TokenRepository
    private let authRepository: AuthAPIRepository
    private let userDefaultsRepository: UserDefaultsRepository

    public init(
        termsAgreementsFactory: TermsAgreementFactory,
        appleProvider: SocialAuthenticatableProvider,
        kakaoProvider: SocialAuthenticatableProvider,
        loginWithAppleUseCase: LoginWithAppleUseCase,
        loginWithKakaoUseCase: LoginWithKakaoUseCase,
        tokenRepository: TokenRepository,
        authRepository: AuthAPIRepository,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.termsAgreementsFactory = termsAgreementsFactory
        self.appleProvider = appleProvider
        self.kakaoProvider = kakaoProvider
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.loginWithKakaoUseCase = loginWithKakaoUseCase
        self.tokenRepository = tokenRepository
        self.authRepository = authRepository
        self.userDefaultsRepository = userDefaultsRepository
    }

    public func make(exitRoute: LoginExitRoute, onLoginCompleted: (() -> Void)?) -> BaseViewController {
        let viewController = LoginViewController(termsAgreementsFactory: termsAgreementsFactory)
        viewController.isBottomTabbarHidden = true

        viewController.reactor = LoginReactor(
            appleProvider: appleProvider,
            kakaoProvider: kakaoProvider,
            loginWithAppleUseCase: loginWithAppleUseCase,
            loginWithKakaoUseCase: loginWithKakaoUseCase,
            tokenRepository: tokenRepository,
            authRepository: authRepository,
            userDefaultsRepository: userDefaultsRepository
        )

        viewController.routeToHome
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak viewController] in
                switch exitRoute {
                case .home:
                    onLoginCompleted?()
                case .pop:
                    viewController?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: viewController.disposeBag)

        return viewController
    }
}
