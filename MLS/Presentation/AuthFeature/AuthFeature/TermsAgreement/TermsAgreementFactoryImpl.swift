import AuthFeatureInterface
import BaseFeature
import Core

public struct TermsAgreementFactoryImpl: TermsAgreementFactory {
    
    private let onBoardingQuestionFactory: OnBoardingQuestionFactory

    public init(onBoardingQuestionFactory: OnBoardingQuestionFactory) {
        self.onBoardingQuestionFactory = onBoardingQuestionFactory
    }

    public func make() -> BaseViewController {
        let viewController = TermsAgreementViewController(onBoardingFactory: onBoardingQuestionFactory)
        viewController.reactor = TermsAgreementReactor()
        return viewController
    }
}
