import Foundation

import DomainInterface

import RxSwift

public final class AppleLoginProviderMock: SocialAuthenticatableProvider {

    public struct Credential: Encodable {
        var idToken: String?
        var authorizationCode: String?
    }

    public init() {}

    public func getCredential() -> Observable<Encodable> {
        return Observable.just(Credential(idToken: "token", authorizationCode: "token"))
    }
}
