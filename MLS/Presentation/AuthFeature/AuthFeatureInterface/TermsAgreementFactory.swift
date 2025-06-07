import BaseFeature

import DomainInterface

public protocol TermsAgreementFactory {
    func make(credential: Encodable, platform: LoginPlatform) -> BaseViewController
}
