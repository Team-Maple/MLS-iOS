import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct TermsAgreementFactoryImpl: TermsAgreementFactory {
    private let onBoardingQuestionFactory: OnBoardingQuestionFactory

    private let signUpWithKakaoUseCase: SignUpWithKakaoUseCase
    private let signUpWithAppleUseCase: SignUpWithAppleUseCase
    private let fetchTokenUseCase: FetchTokenFromLocalUseCase
    private let updateMarketingAgreementUseCase: UpdateMarketingAgreementUseCase

    public init(
        onBoardingQuestionFactory: OnBoardingQuestionFactory,
        signUpWithKakaoUseCase: SignUpWithKakaoUseCase,
        signUpWithAppleUseCase: SignUpWithAppleUseCase,
        fetchTokenUseCase: FetchTokenFromLocalUseCase,
        updateMarketingAgreementUseCase: UpdateMarketingAgreementUseCase
    ) {
        self.onBoardingQuestionFactory = onBoardingQuestionFactory
        self.signUpWithKakaoUseCase = signUpWithKakaoUseCase
        self.signUpWithAppleUseCase = signUpWithAppleUseCase
        self.fetchTokenUseCase = fetchTokenUseCase
        self.updateMarketingAgreementUseCase = updateMarketingAgreementUseCase
    }

    public func make(credential: Credential, platform: LoginPlatform) -> BaseViewController {
        let viewController = TermsAgreementViewController(onBoardingQuestionFactory: onBoardingQuestionFactory)
        viewController.isBottomTabbarHidden = true
        viewController.reactor = TermsAgreementReactor(
            credential: credential,
            socialPlatform: platform,
            signUpWithKakaoUseCase: signUpWithKakaoUseCase,
            signUpWithAppleUseCase: signUpWithAppleUseCase,
            fetchTokenUseCase: fetchTokenUseCase, updateMarketingAgreementUseCase: updateMarketingAgreementUseCase
        )
        return viewController
    }
}
