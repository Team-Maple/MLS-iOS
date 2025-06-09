import Foundation

import DomainInterface

import RxSwift

public class LoginWithAppleUseCaseImpl: LoginWithAppleUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(credential: Encodable) -> Observable<LoginResponse> {
        return repository.loginWithApple(credential: credential)
    }
}
