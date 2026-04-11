import MLSAuthFeatureInterface

import RxSwift

public protocol SocialCredentialProvider {
    func getCredential() -> Observable<Credential>
}
