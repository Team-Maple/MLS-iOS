import Foundation

import RxSwift

public protocol SocialAuthenticatableProvider {
    associatedtype Credential: Encodable

    func getCredential() -> Observable<Credential>
}
