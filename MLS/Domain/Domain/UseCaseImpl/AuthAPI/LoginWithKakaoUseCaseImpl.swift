import Foundation

import DomainInterface

import RxSwift

public class LoginWithKakaoUseCaseImpl: LoginWithKakaoUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    // 로그인할때 토큰 저장 필요
    public func execute(credential: Credential) -> Observable<LoginResponse> {
        return repository.loginWithKakao(credential: credential)
            .catch { error in
                Observable.error(error)
            }
    }
}
