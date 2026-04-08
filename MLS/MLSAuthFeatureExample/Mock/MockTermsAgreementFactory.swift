import UIKit
import MLSAuthFeature
import MLSAuthFeatureInterface
import MLSCore

final class MockTermsAgreementFactory: TermsAgreementFactory {
    func make(credential: Credential, platform: LoginPlatform) -> BaseViewController {
        let vc = BaseViewController()
        vc.view.backgroundColor = .systemBackground
        return vc
    }
}
