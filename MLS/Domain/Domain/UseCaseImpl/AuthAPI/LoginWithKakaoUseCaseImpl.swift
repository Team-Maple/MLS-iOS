import Foundation

import DomainInterface

import RxSwift

public class LoginWithKakaoUseCaseImpl: LoginWithKakaoUseCase {
    private var authRepository: AuthAPIRepository
    private let tokenRepository: TokenRepository
    private var userDefaultsRepository: UserDefaultsRepository

    public init(authRepository: AuthAPIRepository, tokenRepository: TokenRepository, userDefaultsRepository: UserDefaultsRepository) {
        self.authRepository = authRepository
        self.tokenRepository = tokenRepository
        self.userDefaultsRepository = userDefaultsRepository
    }

    // 로그인할때 토큰 저장 필요
    public func execute(credential: Credential) -> Observable<LoginResponse> {
        return authRepository.loginWithKakao(credential: credential)
            .flatMap { response -> Observable<LoginResponse> in
                let saveAccess = self.tokenRepository.saveToken(type: .accessToken, value: response.accessToken)
                let saveRefresh = self.tokenRepository.saveToken(type: .refreshToken, value: response.refreshToken)
                let savePlatform = self.userDefaultsRepository.savePlatform(platform: .apple)

                // ✅ 모든 저장 결과 확인
                switch (saveAccess, saveRefresh) {
                case (.success, .success):
                    return savePlatform.andThen(Observable.just(response))
                default:
                    return Observable.error(
                        TokenRepositoryError.dataConversionError(message: "Failed to save tokens")
                    )
                }
            }
            .catch { error in
                Observable.error(error)
            }
    }
}
