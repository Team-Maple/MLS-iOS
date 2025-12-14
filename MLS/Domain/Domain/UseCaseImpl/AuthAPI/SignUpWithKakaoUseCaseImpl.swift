import DomainInterface
import Foundation
import RxSwift

public final class SignUpWithKakaoUseCaseImpl: SignUpWithKakaoUseCase {
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

    public func execute(
        credential: Credential,
        isMarketingAgreement: Bool,
        fcmToken: String?
    ) -> Observable<SignUpResponse> {
        return authRepository
            .signUpWithKakao(credential: credential, isMarketingAgreement: isMarketingAgreement, fcmToken: fcmToken)
            .flatMap { response -> Observable<SignUpResponse> in
                let saveAccess = self.tokenRepository.saveToken(type: .accessToken, value: response.accessToken)
                let saveRefresh = self.tokenRepository.saveToken(type: .refreshToken, value: response.refreshToken)
                let savePlatform = self.userDefaultsRepository.savePlatform(platform: .kakao)

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
