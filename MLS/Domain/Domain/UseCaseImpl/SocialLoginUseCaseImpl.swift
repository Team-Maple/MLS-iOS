import Foundation

import DomainInterface

import RxSwift

public class SocialLoginUseCaseImpl: SocialLoginUseCase {
    public var provider: any SocialAuthenticatableProvider

    public init(provider: any SocialAuthenticatableProvider) {
        self.provider = provider
    }

    public func execute() -> Observable<any Encodable> {
        return provider.getCredential()
    }
}
