import Foundation

import DomainInterface

import RxSwift

public class SignUpWithAppleUseCaseImpl: SignUpWithAppleUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(credential: Credential, isMarketingAgreement: Bool, fcmToken: String) -> Observable<SignUpResponse> {
        return repository.signUpWithApple(credential: credential, isMarketingAgreement: isMarketingAgreement, fcmToken: fcmToken)
    }
}
