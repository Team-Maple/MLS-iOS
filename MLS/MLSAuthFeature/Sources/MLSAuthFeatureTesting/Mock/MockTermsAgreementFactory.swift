import MLSAuthFeatureInterface
import MLSCore

public final class MockTermsAgreementFactory: TermsAgreementFactory {
    public init() {}

    public func make(credential: Credential, platform: LoginPlatform) -> BaseViewController {
        let vc = BaseViewController()
        vc.view.backgroundColor = .systemBackground
        return vc
    }
}
