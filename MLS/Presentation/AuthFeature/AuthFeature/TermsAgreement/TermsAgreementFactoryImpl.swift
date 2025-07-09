import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct TermsAgreementFactoryImpl: TermsAgreementFactory {

    private let onBoardingQuestionFactory: OnBoardingQuestionFactory

    private let signUpWithKakaoUseCase: SignUpWithKakaoUseCase
    private let signUpWithAppleUseCase: SignUpWithAppleUseCase
    private let saveTokenUseCase: SaveTokenToLocalUseCase
    private let fetchTokenUseCase: FetchTokenFromLocalUseCase

    public init(
        onBoardingQuestionFactory: OnBoardingQuestionFactory,
        signUpWithKakaoUseCase: SignUpWithKakaoUseCase,
        signUpWithAppleUseCase: SignUpWithAppleUseCase,
        saveTokenUseCase: SaveTokenToLocalUseCase,
        fetchTokenUseCase: FetchTokenFromLocalUseCase
    ) {
        self.onBoardingQuestionFactory = onBoardingQuestionFactory
        self.signUpWithKakaoUseCase = signUpWithKakaoUseCase
        self.signUpWithAppleUseCase = signUpWithAppleUseCase
        self.saveTokenUseCase = saveTokenUseCase
        self.fetchTokenUseCase = fetchTokenUseCase
    }

    public func make(credential: Credential, platform: LoginPlatform) -> BaseViewController {
        let viewController = TermsAgreementViewController(onBoardingQuestionFactory: onBoardingQuestionFactory)
        viewController.reactor = TermsAgreementReactor(
            credential: credential,
            socialPlatform: platform,
            signUpWithKakaoUseCase: signUpWithKakaoUseCase,
            signUpWithAppleUseCase: signUpWithAppleUseCase,
            saveTokenUseCase: saveTokenUseCase,
            fetchTokenUseCase: fetchTokenUseCase
        )
        return viewController
    }
}
