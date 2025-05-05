import Foundation

import RxSwift

public protocol SocialAuthenticatable {
    associatedtype Credential: Encodable
    
    func getCredential() ->Observable<Credential>
}
