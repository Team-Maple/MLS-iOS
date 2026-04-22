import MLSCore

public protocol TermsAgreementFactory {
    func make(credential: Credential, platform: LoginPlatform) -> BaseViewController
}
