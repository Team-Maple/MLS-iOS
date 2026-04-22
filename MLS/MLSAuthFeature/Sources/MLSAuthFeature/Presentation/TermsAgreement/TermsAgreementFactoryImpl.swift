import MLSAuthFeatureInterface
import MLSCore

public struct TermsAgreementFactoryImpl: TermsAgreementFactory {
    private let onBoardingQuestionFactory: OnBoardingQuestionFactory
    private let socialSignUpUseCase: SocialSignUpUseCase
    private let tokenRepository: TokenRepository

    public init(
        onBoardingQuestionFactory: OnBoardingQuestionFactory,
        socialSignUpUseCase: SocialSignUpUseCase,
        tokenRepository: TokenRepository
    ) {
        self.onBoardingQuestionFactory = onBoardingQuestionFactory
        self.socialSignUpUseCase = socialSignUpUseCase
        self.tokenRepository = tokenRepository
    }

    public func make(credential: Credential, platform: LoginPlatform) -> BaseViewController {
        let viewController = TermsAgreementViewController(onBoardingQuestionFactory: onBoardingQuestionFactory)
        viewController.isBottomTabbarHidden = true
        viewController.reactor = TermsAgreementReactor(
            credential: credential,
            socialPlatform: platform,
            socialSignUpUseCase: socialSignUpUseCase,
            tokenRepository: tokenRepository
        )
        return viewController
    }
}
