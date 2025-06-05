import AuthFeatureInterface
import BaseFeature

public struct TermsAgreementFactoryImpl: TermsAgreementFactory {

    private let onBoardingQuestionFactory: OnBoardingQuestionFactory

    public init(onBoardingQuestionFactory: OnBoardingQuestionFactory) {
        self.onBoardingQuestionFactory = onBoardingQuestionFactory
    }

    public func make(credential: Encodable) -> BaseViewController {
        let viewController = TermsAgreementViewController(onBoardingQuestionFactory: onBoardingQuestionFactory)
        viewController.reactor = TermsAgreementReactor(credential: credential)
        return viewController
    }
}
