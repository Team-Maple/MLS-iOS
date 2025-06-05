import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct LoginFactoryImpl: LoginFactory {

    private let termsAgreementsFactory: TermsAgreementFactory
    private let appleLoginUseCase: SocialLoginUseCase
    private let kakaoLoginUseCase: SocialLoginUseCase
    private let loginWithAppleUseCase: LoginWithAppleUseCase
    private let loginWithKakaoUseCase: LoginWithKakaoUseCase

    public init(
        termsAgreementsFactory: TermsAgreementFactory,
        appleLoginUseCase: SocialLoginUseCase,
        kakaoLoginUseCase: SocialLoginUseCase,
        loginWithAppleUseCase: LoginWithAppleUseCase,
        loginWithKakaoUseCase: LoginWithKakaoUseCase
    ) {
        self.termsAgreementsFactory = termsAgreementsFactory
        self.appleLoginUseCase = appleLoginUseCase
        self.kakaoLoginUseCase = kakaoLoginUseCase
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.loginWithKakaoUseCase = loginWithKakaoUseCase
    }

    public func make(
        isReLogin: Bool
    ) -> BaseViewController {
        let viewController = LoginViewController(isRelogin: isReLogin, termsAgreementsFactory: termsAgreementsFactory)
        viewController.reactor = LoginReactor(
            appleLoginUseCase: appleLoginUseCase,
            kakaoLoginUseCase: kakaoLoginUseCase,
            loginWithAppleUseCase: loginWithAppleUseCase,
            loginWithKakaoUseCase: loginWithKakaoUseCase
        )
        return viewController
    }
}
