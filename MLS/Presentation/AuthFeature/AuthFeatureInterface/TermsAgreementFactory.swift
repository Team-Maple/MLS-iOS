import BaseFeature

import DomainInterface

public protocol TermsAgreementFactory {
    func make(credential: Credential, platform: LoginPlatform) -> BaseViewController
}
