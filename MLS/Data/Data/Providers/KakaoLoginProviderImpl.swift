import DomainInterface

import RxSwift

class KakaoLoginProviderImpl: SocialAuthenticatableProvider {
    public struct Credential: Encodable {
        var idToken: String?
        var authorizationCode: String?
    }
    
    private let authServiceResponse = PublishSubject<Credential>()
    
    func getCredential() -> RxSwift.Observable<Credential> {
        return authServiceResponse
    }
}
