import UIKit

import AuthFeature
import AuthFeatureInterface
import BaseFeature
import Core
import Data
import DataMock
import DesignSystem
import DictionaryFeatureInterface
import Domain
import DomainInterface

import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ImageLoader.shared.configure.diskCacheCountLimit = 10
        FontManager.registerFonts()
        registerDependencies()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

private extension AppDelegate {
    func registerDependencies() {
        registerProvider()
        registerRepository()
        registerUseCase()
        registerFactory()
    }

    func registerProvider() {
        DIContainer.register(type: NetworkProvider.self) {
            NetworkProviderImpl()
        }
        DIContainer.register(type: SocialAuthenticatableProvider.self, name: "kakao") {
            KakaoLoginProviderImpl()
        }
        DIContainer.register(type: SocialAuthenticatableProvider.self, name: "apple") {
            AppleLoginProviderImpl()
        }
    }

    func registerRepository() {
        DIContainer.register(type: AuthAPIRepository.self) {
            AuthAPIRepositoryImpl(
                provider: DIContainer.resolve(type: NetworkProvider.self),
                interceptor: TokenInterceptor(fetchTokenUseCase: DIContainer.resolve(type: FetchTokenFromLocalUseCase.self))
            )
        }
        DIContainer.register(type: TokenRepository.self) {
            KeyChainRepositoryImpl()
        }
        DIContainer.register(type: UserDefaultsRepository.self) {
            UserDefaultsRepositoryImpl()
        }
    }

    func registerUseCase() {
        DIContainer.register(type: FetchSocialCredentialUseCase.self, name: "kakao") {
            let provider = DIContainer.resolve(type: SocialAuthenticatableProvider.self, name: "kakao")
            return SocialLoginUseCaseImpl(provider: provider)
        }
        DIContainer.register(type: FetchSocialCredentialUseCase.self, name: "apple") {
            let provider = DIContainer.resolve(type: SocialAuthenticatableProvider.self, name: "apple")
            return SocialLoginUseCaseImpl(provider: provider)
        }
        DIContainer.register(type: CheckEmptyLevelAndRoleUseCase.self) {
            CheckEmptyLevelAndRoleUseCaseImpl()
        }
        DIContainer.register(type: CheckValidLevelUseCase.self) {
            CheckValidLevelUseCaseImpl()
        }
        DIContainer.register(type: FetchJobListUseCase.self) {
            FetchJobListUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: LoginWithAppleUseCase.self) {
            LoginWithAppleUseCaseImpl(authRepository: DIContainer.resolve(type: AuthAPIRepository.self), tokenRepository: DIContainer.resolve(type: TokenRepository.self), userDefaultsRepository: DIContainer.resolve(type: UserDefaultsRepository.self))
        }
        DIContainer.register(type: LoginWithKakaoUseCase.self) {
            LoginWithKakaoUseCaseImpl(authRepository: DIContainer.resolve(type: AuthAPIRepository.self), tokenRepository: DIContainer.resolve(type: TokenRepository.self), userDefaultsRepository: DIContainer.resolve(type: UserDefaultsRepository.self))
        }
        DIContainer.register(type: SignUpWithAppleUseCase.self) {
            SignUpWithAppleUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: SignUpWithKakaoUseCase.self) {
            SignUpWithKakaoUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: UpdateUserInfoUseCase.self) {
            UpdateUserInfoUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: FetchTokenFromLocalUseCase.self) {
            FetchTokenFromLocalUseCaseImpl(repository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: SaveTokenToLocalUseCase.self) {
            SaveTokenToLocalUseCaseImpl(repository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: DeleteTokenFromLocalUseCase.self) {
            DeleteTokenFromLocalUseCaseImpl(repository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: UpdateMarketingAgreementUseCase.self) {
            UpdateMarketingAgreementUseCaseImpl(authRepository: DIContainer.resolve(type: AuthAPIRepository.self), tokenRepository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: PutFCMTokenUseCase.self) {
            PutFCMTokenUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: CheckNotificationPermissionUseCase.self) {
            CheckNotificationPermissionUseCaseImpl()
        }
        DIContainer.register(type: OpenNotificationSettingUseCase.self) {
            OpenNotificationSettingUseCaseImpl()
        }
        DIContainer.register(type: UpdateNotificationAgreementUseCase.self) {
            UpdateNotificationAgreementUseCaseImpl(authRepository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryMapListUseCase.self) {
            FetchDictionaryMapListUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryItemListUseCase.self) {
            FetchDictionaryItemListUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryQuestListUseCase.self) {
            FetchDictionaryQuestListUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryNpcListUseCase.self) {
            FetchDictionaryNpcListUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryMonsterListUseCase.self) {
            FetchDictionaryMonsterListUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailMonsterUseCase.self) {
            FetchDictionaryDetailMonsterUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailMonsterItemsUseCase.self) {
            FetchDictionaryDetailMonsterDropItemUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailMonsterMapUseCase.self) {
            FetchDictionaryDetailMonsterMapUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailNpcUseCase.self) {
            FetchDictionaryDetailNpcUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailNpcQuestUseCase.self) {
            FetchDictionaryDetailNpcQuestUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailNpcMapUseCase.self) {
            FetchDictionaryDetailNpcMapUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailItemUseCase.self) {
            FetchDictionaryDetailItemUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailItemDropMonsterUseCase.self) {
            FetchDictionaryDetailItemDropMonsterUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailQuestUseCase.self) {
            FetchDictionaryDetailQuestUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailQuestLinkedQuestsUseCase.self) {
            FetchDictionaryDetailQuestLinkedQuestsUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailMapUseCase.self) {
            FetchDictionaryDetailMapUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailMapSpawnMonsterUseCase.self) {
            FetchDictionaryDetailMapSpawnMonsterUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailMapNpcUseCase.self) {
            FetchDictionaryDetailMapNpcUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchPlatformUseCase.self) {
            FetchPlatformUseCaseImpl(repository: DIContainer.resolve(type: UserDefaultsRepository.self))
        }
    }

    func registerFactory() {
        DIContainer.register(type: OnBoardingNotificationSheetFactory.self) {
            OnBoardingNotificationSheetFactoryImpl(
                checkNotificationPermissionUseCase: DIContainer
                    .resolve(type: CheckNotificationPermissionUseCase.self),
                openNotificationSettingUseCase: DIContainer
                    .resolve(type: OpenNotificationSettingUseCase.self),
                updateNotificationAgreementUseCase: DIContainer
                    .resolve(type: UpdateNotificationAgreementUseCase.self), updateUserInfoUseCase: DIContainer.resolve(type: UpdateUserInfoUseCase.self), dictionaryMainViewFactory: DictionaryFactoryMock()
            )
        }
        DIContainer.register(type: OnBoardingNotificationFactory.self) {
            OnBoardingNotificationFactoryImpl(onBoardingNotificationSheetFactory: DIContainer.resolve(type: OnBoardingNotificationSheetFactory.self))
        }
        DIContainer.register(type: OnBoardingInputFactory.self) {
            OnBoardingInputFactoryImpl(
                checkEmptyUseCase: DIContainer.resolve(type: CheckEmptyLevelAndRoleUseCase.self),
                checkValidLevelUseCase: DIContainer.resolve(type: CheckValidLevelUseCase.self),
                fetchJobListUseCase: DIContainer.resolve(type: FetchJobListUseCase.self),
                updateUserInfoUseCase: DIContainer.resolve(type: UpdateUserInfoUseCase.self),
                onBoardingNotificationFactory: DIContainer.resolve(type: OnBoardingNotificationFactory.self)
            )
        }
        DIContainer.register(type: OnBoardingQuestionFactory.self) {
            OnBoardingQuestionFactoryImpl(
                onBoardingInputFactory: DIContainer.resolve(type: OnBoardingInputFactory.self)
            )
        }
        DIContainer.register(type: TermsAgreementFactory.self) {
            TermsAgreementFactoryImpl(
                onBoardingQuestionFactory: DIContainer.resolve(type: OnBoardingQuestionFactory.self),
                signUpWithKakaoUseCase: DIContainer.resolve(type: SignUpWithKakaoUseCase.self),
                signUpWithAppleUseCase: DIContainer.resolve(type: SignUpWithAppleUseCase.self),
                saveTokenUseCase: DIContainer.resolve(type: SaveTokenToLocalUseCase.self),
                fetchTokenUseCase: DIContainer.resolve(type: FetchTokenFromLocalUseCase.self), updateMarketingAgreementUseCase: DIContainer.resolve(type: UpdateMarketingAgreementUseCase.self)
            )
        }
        DIContainer.register(type: LoginFactory.self) {
            LoginFactoryImpl(
                termsAgreementsFactory: DIContainer.resolve(type: TermsAgreementFactory.self),
                appleLoginUseCase: DIContainer.resolve(type: FetchSocialCredentialUseCase.self, name: "apple"),
                kakaoLoginUseCase: DIContainer.resolve(type: FetchSocialCredentialUseCase.self, name: "kakao"),
                loginWithAppleUseCase: DIContainer.resolve(type: LoginWithAppleUseCase.self),
                loginWithKakaoUseCase: DIContainer.resolve(type: LoginWithKakaoUseCase.self),
                fetchTokenUseCase: DIContainer.resolve(type: FetchTokenFromLocalUseCase.self),
                putFCMTokenUseCase: DIContainer.resolve(type: PutFCMTokenUseCase.self),
                fetchPlatformUseCase: DIContainer.resolve(type: FetchPlatformUseCase.self)
            )
        }
    }
}
