import MLSAuthFeatureInterface
import MLSCore

public struct TermsAgreementFactoryImpl: TermsAgreementFactory {
    private let onBoardingQuestionFactory: OnBoardingQuestionFactory

    private let signUpWithKakaoUseCase: SignUpWithKakaoUseCase
    private let signUpWithAppleUseCase: SignUpWithAppleUseCase
    private let tokenRepository: TokenRepository

    public init(
        onBoardingQuestionFactory: OnBoardingQuestionFactory,
        signUpWithKakaoUseCase: SignUpWithKakaoUseCase,
        signUpWithAppleUseCase: SignUpWithAppleUseCase,
        tokenRepository: TokenRepository
    ) {
        self.onBoardingQuestionFactory = onBoardingQuestionFactory
        self.signUpWithKakaoUseCase = signUpWithKakaoUseCase
        self.signUpWithAppleUseCase = signUpWithAppleUseCase
        self.tokenRepository = tokenRepository
    }

    public func make(credential: Credential, platform: LoginPlatform) -> BaseViewController {
        let viewController = TermsAgreementViewController(onBoardingQuestionFactory: onBoardingQuestionFactory)
        viewController.isBottomTabbarHidden = true
        viewController.reactor = TermsAgreementReactor(
            credential: credential,
            socialPlatform: platform,
            signUpWithKakaoUseCase: signUpWithKakaoUseCase,
            signUpWithAppleUseCase: signUpWithAppleUseCase,
            tokenRepository: tokenRepository
        )
        return viewController
    }
}
