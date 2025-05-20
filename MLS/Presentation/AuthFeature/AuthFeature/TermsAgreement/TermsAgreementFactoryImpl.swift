import UIKit

import AuthFeatureInterface

public struct TermsAgreementFactoryImpl: TermsAgreementFactory {
    
    public init() {}
    
    public func make() -> UIViewController {
        let viewController = TermsAgreementViewController()
        viewController.reactor = TermsAgreementReactor()
        return viewController
    }
}
