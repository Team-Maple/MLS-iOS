import Foundation

import DomainInterface

import RxSwift

public class SocialLoginUseCaseImpl: FetchSocialCredentialUseCase {
    public var provider: any SocialAuthenticatableProvider

    public init(provider: any SocialAuthenticatableProvider) {
        self.provider = provider
    }

    public func execute() -> Observable<Credential> {
        return provider.getCredential()
    }
}
