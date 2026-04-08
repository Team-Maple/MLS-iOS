import Foundation

import RxSwift

public protocol SocialAuthenticatableProvider {
    func getCredential() -> Observable<Credential>
}
