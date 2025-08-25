import Foundation

import Data
import DomainInterface

import RxSwift

public final class AppleLoginProviderMock: SocialAuthenticatableProvider {
    public init() {}

    public func getCredential() -> Observable<Credential> {
        return Observable.just(AppleCredential(token: "token", providerID: "token"))
    }
}
