import Foundation

public protocol SocialLoginUseCase {
    var provider: any SocialAuthenticatable { get set }
    
    func execute() -> Encodable
}
