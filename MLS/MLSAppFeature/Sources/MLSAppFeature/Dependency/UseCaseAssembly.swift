import MLSAppFeatureInterface
import MLSAuthFeature
import MLSAuthFeatureInterface
import MLSCore
import MLSDictionaryFeature
import MLSDictionaryFeatureInterface
import MLSMyPageFeature
import MLSMyPageFeatureInterface

public enum UseCaseAssembly {
    public static func register() {
        DIContainer.register(type: CheckEmptyLevelAndRoleUseCase.self) {
            CheckEmptyLevelAndRoleUseCaseImpl()
        }
        DIContainer.register(type: CheckValidLevelUseCase.self) {
            CheckValidLevelUseCaseImpl()
        }
        DIContainer.register(type: SocialLoginUseCase.self) {
            SocialLoginUseCaseImpl(
                authRepository: DIContainer.resolve(
                    type: AuthAPIRepository.self
                ),
                tokenRepository: DIContainer.resolve(
                    type: TokenRepository.self
                ),
                userDefaultsRepository: DIContainer.resolve(
                    type: UserDefaultsRepository.self)
            )
        }
        DIContainer.register(type: SocialSignUpUseCaseImpl.self) {
            SocialSignUpUseCaseImpl(
                authRepository: DIContainer.resolve(type: AuthAPIRepository.self),
                tokenRepository: DIContainer.resolve(type: TokenRepository.self),
                userDefaultsRepository: DIContainer.resolve(type: UserDefaultsRepository.self)
            )
        }
        DIContainer.register(type: CheckNotificationPermissionUseCase.self) {
            CheckNotificationPermissionUseCaseImpl()
        }
        DIContainer.register(type: CheckLoginUseCase.self) {
            CheckLoginUseCaseImpl(
                authRepository: DIContainer.resolve(
                    type: AuthAPIRepository.self
                ),
                tokenRepository: DIContainer.resolve(type: TokenRepository.self)
            )
        }
        DIContainer.register(type: FetchProfileUseCase.self) {
            FetchProfileUseCaseImpl(
                repository: DIContainer.resolve(type: MyPageRepository.self)
            )
        }
        DIContainer.register(type: CheckNickNameUseCase.self) {
            CheckNickNameUseCaseImpl()
        }
        DIContainer.register(type: LogoutUseCase.self) {
            LogoutUseCaseImpl(
                repository: DIContainer.resolve(type: TokenRepository.self)
            )
        }
        DIContainer.register(type: WithdrawUseCase.self) {
            WithdrawUseCaseImpl(
                authRepository: DIContainer.resolve(
                    type: AuthAPIRepository.self
                ),
                tokenRepository: DIContainer.resolve(type: TokenRepository.self)
            )
        }
        DIContainer.register(type: ParseItemFilterResultUseCase.self) {
            ParseItemFilterResultUseCaseImpl()
        }
        DIContainer.register(type: FetchVisitDictionaryDetailUseCase.self) {
            FetchVisitDictionaryDetailUseCaseImpl(repository: DIContainer.resolve(type: DictionaryUserDefaultsRepository.self))
        }
        DIContainer.register(type: SocialSignUpUseCase.self) {
            SocialSignUpUseCaseImpl(
                authRepository: DIContainer
                    .resolve(type: AuthAPIRepository.self),
                tokenRepository: DIContainer
                    .resolve(type: TokenRepository.self),
                userDefaultsRepository: DIContainer
                    .resolve(type: UserDefaultsRepository.self)
            )
        }
        DIContainer.register(type: UpdateCheckerUseCaseProtocol.self) {
            UpdateCheckerUseCase(
                appID: AppInfo.appStoreID,
                appStoreRepository: DIContainer.resolve(type: AppStoreRepositoryProtocol.self),
                skipRepository: DIContainer.resolve(type: UpdateSkipRepositoryProtocol.self)
            )
        }
    }
}
