import BaseFeature

public protocol TermsAgreementFactory {
    func make(credential: Encodable) -> BaseViewController
}
