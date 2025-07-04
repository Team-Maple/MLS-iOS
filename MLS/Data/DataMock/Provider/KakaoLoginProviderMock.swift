import Foundation

import Data
import DomainInterface

import RxSwift

public final class KakaoLoginProviderMock: SocialAuthenticatableProvider {
    public init() {}

    public func getCredential() -> Observable<Credential> {
        return Observable.just(KakaoCredential(token: "Token", providerID: "email"))
    }
}
