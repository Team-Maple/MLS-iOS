import Foundation

import DomainInterface

import RxSwift

public final class KakaoLoginProviderMock: SocialAuthenticatableProvider {
    public struct Credential: Encodable {
        var accessToken: String?
        var email: String?
    }

    public init() {}

    public func getCredential() -> Observable<Encodable> {
        return Observable.just(Credential(accessToken: "Token", email: "email"))
    }
}
