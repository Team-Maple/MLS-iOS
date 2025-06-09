import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct TermsAgreementFactoryImpl: TermsAgreementFactory {

    private let onBoardingQuestionFactory: OnBoardingQuestionFactory

    private let signUpWithKakaoUseCase: SignUpWithKakaoUseCase
    private let signUpWithAppleUseCase: SignUpWithAppleUseCase
    private let saveTokenUseCase: SaveTokenToLocalUseCase

    public init(
        onBoardingQuestionFactory: OnBoardingQuestionFactory,
        signUpWithKakaoUseCase: SignUpWithKakaoUseCase,
        signUpWithAppleUseCase: SignUpWithAppleUseCase,
        saveTokenUseCase: SaveTokenToLocalUseCase
    ) {
        self.onBoardingQuestionFactory = onBoardingQuestionFactory
        self.signUpWithKakaoUseCase = signUpWithKakaoUseCase
        self.signUpWithAppleUseCase = signUpWithAppleUseCase
        self.saveTokenUseCase = saveTokenUseCase
    }

    public func make(credential: any Encodable, platform: LoginPlatform) -> BaseViewController {
        let viewController = TermsAgreementViewController(onBoardingQuestionFactory: onBoardingQuestionFactory)
        viewController.reactor = TermsAgreementReactor(
            credential: credential,
            socialPlatform: platform,
            signUpWithKakaoUseCase: signUpWithKakaoUseCase,
            signUpWithAppleUseCase: signUpWithAppleUseCase,
            saveTokenUseCase: saveTokenUseCase
        )
        return viewController
    }
}
