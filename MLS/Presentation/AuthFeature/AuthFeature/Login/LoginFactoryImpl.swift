import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct LoginFactoryImpl: LoginFactory {

    public init() {}

    public func make(
        isReLogin: Bool,
        termsAgreementsFactory: TermsAgreementFactory,
        appleLoginUseCase: SocialLoginUseCase,
        kakaoLoginUseCase: SocialLoginUseCase
    ) -> BaseViewController {
        let viewController = LoginViewController(isRelogin: isReLogin, termsAgreementsFactory: termsAgreementsFactory)
        viewController.reactor = LoginReactor(appleLoginUseCase: appleLoginUseCase, kakaoLoginUseCase: kakaoLoginUseCase)
        return viewController
    }
}
