import Foundation

public protocol SocialAuthenticatable {
    associatedtype Credential: Encodable
    
    func getCredential() -> Credential
}
