import BaseFeature
import DomainInterface

public protocol LoginFactory {
    func make(
        isReLogin: Bool,
        termsAgreementsFactory: TermsAgreementFactory,
        appleLoginUseCase: SocialLoginUseCase,
        kakaoLoginUseCase: SocialLoginUseCase
    ) -> BaseViewController
}
