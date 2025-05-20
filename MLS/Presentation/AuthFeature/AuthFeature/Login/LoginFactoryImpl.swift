import UIKit

import AuthFeatureInterface

public struct LoginFactoryImpl: LoginFactory {
    
    public init() {}
    
    public func make(isReLogin: Bool, termsAgreementsFactory: TermsAgreementFactory) -> UIViewController {
        let viewController = LoginViewController(isRelogin: isReLogin, termsAgreementsFactory: termsAgreementsFactory)
        viewController.reactor = LoginReactor()
        return viewController
    }
}
