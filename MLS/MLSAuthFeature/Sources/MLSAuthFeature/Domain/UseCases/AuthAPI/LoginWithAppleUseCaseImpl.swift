import MLSAuthFeatureInterface

import RxSwift

public class LoginWithAppleUseCaseImpl: LoginWithAppleUseCase {
    private let authRepository: AuthAPIRepository
    private let tokenRepository: TokenRepository
    private let userDefaultsRepository: UserDefaultsRepository

    public init(
        authRepository: AuthAPIRepository,
        tokenRepository: TokenRepository,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.authRepository = authRepository
        self.tokenRepository = tokenRepository
        self.userDefaultsRepository = userDefaultsRepository
    }

    public func execute(credential: Credential) -> Observable<LoginResponse> {
        return authRepository.loginWithApple(credential: credential)
            .flatMap { response -> Observable<LoginResponse> in
                let saveAccess = self.tokenRepository.saveToken(type: .accessToken, value: response.accessToken)
                let saveRefresh = self.tokenRepository.saveToken(type: .refreshToken, value: response.refreshToken)
                let savePlatform = self.userDefaultsRepository.savePlatform(platform: .apple)

                guard case (.success, .success) = (saveAccess, saveRefresh) else {
                    return Observable.error(TokenRepositoryError.dataConversionError(message: "Failed to save tokens"))
                }

                var fcmToken: String?
                if case .success(let token) = self.tokenRepository.fetchToken(type: .fcmToken) {
                    fcmToken = token
                }

                let fcmUpdate = if let fcmToken {
                    self.authRepository.fcmToken(fcmToken: fcmToken)
                        .catch { error in
                            print("FCM token update failed: \(error)")
                            return .empty()
                        }
                } else {
                    Completable.empty()
                }
                return fcmUpdate.andThen(savePlatform).andThen(Observable.just(response))
            }
            .catch { error in
                Observable.error(error)
            }
    }
}
