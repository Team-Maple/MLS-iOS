import DomainInterface

public struct AppleCredential: Credential {
    public var token: String?
    public var authorizationCode: String?
    
    public init(token: String? = nil, authorizationCode: String? = nil) {
        self.token = token
        self.authorizationCode = authorizationCode
    }
}
