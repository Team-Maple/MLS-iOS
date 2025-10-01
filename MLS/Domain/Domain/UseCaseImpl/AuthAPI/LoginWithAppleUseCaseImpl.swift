import Foundation

import DomainInterface

import RxSwift

public class LoginWithAppleUseCaseImpl: LoginWithAppleUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    // 로그인할때 토큰 저장 필요
    public func execute(credential: Credential) -> Observable<LoginResponse> {
        return repository.loginWithApple(credential: credential)
    }
}
