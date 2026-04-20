import MLSAuthFeatureInterface

import RxSwift

public final class SocialSignUpUseCaseImpl: SocialSignUpUseCase {
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

    public func execute(credential: Credential, platform: LoginPlatform, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse> {
        let signUpObservable: Observable<SignUpResponse>
        switch platform {
        case .apple:
            signUpObservable = authRepository.signUpWithApple(credential: credential, isMarketingAgreement: isMarketingAgreement, fcmToken: fcmToken)
        case .kakao:
            signUpObservable = authRepository.signUpWithKakao(credential: credential, isMarketingAgreement: isMarketingAgreement, fcmToken: fcmToken)
        }

        return signUpObservable
            .flatMap { response -> Observable<SignUpResponse> in
                let saveAccess = self.tokenRepository.saveToken(type: .accessToken, value: response.accessToken)
                let saveRefresh = self.tokenRepository.saveToken(type: .refreshToken, value: response.refreshToken)
                let savePlatform = self.userDefaultsRepository.savePlatform(platform: platform)

                switch (saveAccess, saveRefresh) {
                case (.success, .success):
                    return savePlatform.andThen(Observable.just(response))
                default:
                    return Observable.error(TokenRepositoryError.dataConversionError(message: "Failed to save tokens"))
                }
            }
            .catch { error in
                Observable.error(error)
            }
    }
}
