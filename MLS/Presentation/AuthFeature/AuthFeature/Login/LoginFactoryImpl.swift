import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct LoginFactoryImpl: LoginFactory {

    private let termsAgreementsFactory: TermsAgreementFactory
    private let appleLoginUseCase: SocialLoginUseCase
    private let kakaoLoginUseCase: SocialLoginUseCase

    public init(
        termsAgreementsFactory: TermsAgreementFactory,
        appleLoginUseCase: SocialLoginUseCase,
        kakaoLoginUseCase: SocialLoginUseCase
    ) {
        self.termsAgreementsFactory = termsAgreementsFactory
        self.appleLoginUseCase = appleLoginUseCase
        self.kakaoLoginUseCase = kakaoLoginUseCase
    }

    public func make(
        isReLogin: Bool
    ) -> BaseViewController {
        let viewController = LoginViewController(isRelogin: isReLogin, termsAgreementsFactory: termsAgreementsFactory)
        viewController.reactor = LoginReactor(appleLoginUseCase: appleLoginUseCase, kakaoLoginUseCase: kakaoLoginUseCase)
        return viewController
    }
}
