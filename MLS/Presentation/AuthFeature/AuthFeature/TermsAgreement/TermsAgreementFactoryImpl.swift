import BaseFeature
import AuthFeatureInterface

public struct TermsAgreementFactoryImpl: TermsAgreementFactory {
    
    public init() {}
    
    public func make() -> BaseViewController {
        let viewController = TermsAgreementViewController()
        viewController.reactor = TermsAgreementReactor()
        return viewController
    }
}
