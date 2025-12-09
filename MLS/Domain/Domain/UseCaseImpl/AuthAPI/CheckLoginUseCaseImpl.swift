import DomainInterface

import RxRelay
import RxSwift

public final class CheckLoginUseCaseImpl: CheckLoginUseCase {
    private let authRepository: AuthAPIRepository
    private let tokenRepository: TokenRepository

    public init(authRepository: AuthAPIRepository, tokenRepository: TokenRepository) {
        self.authRepository = authRepository
        self.tokenRepository = tokenRepository
    }

    public func execute() -> Observable<Bool> {
        switch tokenRepository.fetchToken(type: .refreshToken) {
        case .success(let token):
            guard !token.isEmpty else { return .just(false) }

            return authRepository.reissueToken(refreshToken: token)
                .map { [weak self] response in
                    guard let self else { return false }

                    let accessResult = self.tokenRepository.saveToken(type: .accessToken, value: response.accessToken)
                    let refreshResult = self.tokenRepository.saveToken(type: .refreshToken, value: response.refreshToken)

                    switch (accessResult, refreshResult) {
                    case (.success, .success):
                        return true
                    case (.failure(let error), _),
                         (_, .failure(let error)):
                        print("Token 저장 실패:", error.localizedDescription)
                        return false
                    }
                }
                .catch { error in
                    print("reissueToken 실패:", error.localizedDescription)
                    return .just(false)
                }

        case .failure:
            return .just(false)
        }
    }
}
