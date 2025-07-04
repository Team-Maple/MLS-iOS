import Foundation

import DomainInterface

import RxSwift

public class SignUpWithKakaoUseCaseImpl: SignUpWithKakaoUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(credential: Credential, isMarketingAgreement: Bool) -> Observable<SignUpResponse> {
        return repository.signUpWithKakao(credential: credential, isMarketingAgreement: isMarketingAgreement)
    }
}
