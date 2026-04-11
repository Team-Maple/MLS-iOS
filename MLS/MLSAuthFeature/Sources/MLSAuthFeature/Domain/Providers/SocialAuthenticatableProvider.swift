import MLSAuthFeatureInterface

import RxSwift

public protocol SocialAuthenticatableProvider {
    func getCredential() -> Observable<Credential>
}
