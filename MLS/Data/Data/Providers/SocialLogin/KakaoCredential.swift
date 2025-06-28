import DomainInterface

public struct KakaoCredential: Credential {
    public let token: String?
    public let email: String?

    public init(token: String?, email: String?) {
        self.token = token
        self.email = email
    }
}
