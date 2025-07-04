import Foundation

import DomainInterface

import RxSwift

public class LoginWithKakaoUseCaseImpl: LoginWithKakaoUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(credential: Credential) -> Observable<LoginResponse> {
        return repository.loginWithKakao(credential: credential)
            .catch { error in
                return Observable.error(error)
            }
    }
}
