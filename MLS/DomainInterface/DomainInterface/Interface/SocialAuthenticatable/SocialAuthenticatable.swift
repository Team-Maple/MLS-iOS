import Foundation

protocol SocialAuthenticatable {
    associatedtype Credential: Encodable
    
    func getCredential() -> Credential
}
