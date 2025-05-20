import BaseFeature

public protocol LoginFactory {
    func make(isReLogin: Bool, termsAgreementsFactory: TermsAgreementFactory) -> BaseViewController
}
