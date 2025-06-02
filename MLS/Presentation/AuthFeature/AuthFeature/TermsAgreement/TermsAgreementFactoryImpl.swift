import AuthFeatureInterface
import BaseFeature
import Core

public struct TermsAgreementFactoryImpl: TermsAgreementFactory {
    
    public init() {}
    
    public func make() -> BaseViewController {
        let viewController = TermsAgreementViewController(onBoardingFactory: DIContainer.resolve(type: OnBoardingFactory.self, name: "onBoardingQuestion"))
        viewController.reactor = TermsAgreementReactor()
        return viewController
    }
}
