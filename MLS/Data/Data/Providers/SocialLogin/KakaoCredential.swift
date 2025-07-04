import DomainInterface

public struct KakaoCredential: Credential {
    public let token: String
    public let providerID: String

    public init(token: String, providerID: String) {
        self.token = token
        self.providerID = providerID
    }
}
