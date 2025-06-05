import Foundation

import DomainInterface

import RxSwift

public class SignUpWithAppleUseCaseImpl: SignUpWithAppleUseCase {
    private var repository: AuthAPIRepository
    
    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(credential: Encodable, isMarketingAgreement: Bool) -> Observable<SignUpResponse> {
        return repository.signUpWithApple(credential: credential, isMarketingAgreement: isMarketingAgreement)
    }
}
