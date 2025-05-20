import UIKit

public protocol LoginFactory {
    func make(isReLogin: Bool, termsAgreementsFactory: TermsAgreementFactory) -> UIViewController
}
