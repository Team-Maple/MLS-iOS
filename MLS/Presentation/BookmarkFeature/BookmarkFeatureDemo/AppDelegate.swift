// swiftlint:disable function_body_length

import UIKit

import AuthFeature
import AuthFeatureInterface
import BaseFeature
import BookmarkFeature
import BookmarkFeatureInterface
import Core
import Data
import DataMock
import DesignSystem
import DictionaryFeature
import DictionaryFeatureInterface
import Domain
import DomainInterface
import MyPageFeature
import MyPageFeatureInterface

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
            KakaoLoginProviderMock()
        }
        DIContainer.register(type: SocialAuthenticatableProvider.self, name: "apple") {
            AppleLoginProviderMock()
        }
    }

    func registerRepository() {
        DIContainer.register(type: UserDefaultsRespository.self) {
            BookmarkOnBoardingRepositoryImpl()
        }
        DIContainer.register(type: AuthAPIRepository.self) {
            AuthAPIRepositoryMock(provider: DIContainer.resolve(type: NetworkProvider.self))
        }
        DIContainer.register(type: TokenRepository.self) {
            KeyChainRepositoryImpl()
        }
        DIContainer.register(type: DictionaryListRepository.self) {
            return DictionaryListRepositoryImpl(allItems: [
                DictionaryItem(id: "1", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "2", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "3", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "5", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true)
            ])
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
            LoginWithAppleUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: LoginWithKakaoUseCase.self) {
            LoginWithKakaoUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
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
        DIContainer.register(type: FetchDictionaryItemsUseCase.self) {
            FetchDictionaryItemsUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListRepository.self))
        }
        DIContainer.register(type: ToggleBookmarkUseCase.self) {
            ToggleBookmarkUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListRepository.self))
        }
        DIContainer.register(type: FetchNotificationUseCase.self) {
            FetchNotificationUseCaseImpl()
        }
        DIContainer.register(type: GetBookmarkOnboardingUseCase.self) {
            GetBookmarkOnboardingUseCaseImpl(repository: DIContainer.resolve(type: UserDefaultsRespository.self))
        }
        DIContainer.register(type: SetBookmarkOnBoardingUseCase.self) {
            SetBookmarkOnBoardingUseCaseImpl(repository: DIContainer.resolve(type: UserDefaultsRespository.self))
        }
        DIContainer.register(type: CheckLoginUseCase.self) {
            CheckLoginUseCaseImpl(authRepository: DIContainer.resolve(type: AuthAPIRepository.self), tokenRepository: DIContainer.resolve(type: TokenRepository.self))
        }
    }

    func registerFactory() {
        DIContainer.register(type: ItemFilterBottomSheetFactory.self) {
            ItemFilterBottomSheetFactoryImpl()
        }
        DIContainer.register(type: MonsterFilterBottomSheetFactory.self) {
            MonsterFilterBottomSheetFactoryImpl()
        }
        DIContainer.register(type: SortedBottomSheetFactory.self) {
            SortedBottomSheetFactoryImpl()
        }
        DIContainer.register(type: AddCollectionFactory.self) {
            AddCollectionFactoryImpl()
        }
        DIContainer.register(type: BookmarkModalFactory.self) {
            BookmarkModalFactoryImpl(addCollectionFactory: DIContainer.resolve(type: AddCollectionFactory.self))
        }
        DIContainer.register(type: DictionaryDetailFactory.self) {
            DictionaryDetailFactoryImpl()
        }
        DIContainer.register(type: DictionaryMainListFactory.self) {
            DictionaryListFactoryImpl(
                fetchDictionaryItemsUseCase: DIContainer.resolve(type: FetchDictionaryItemsUseCase.self),
                toggleBookmarkUseCase: DIContainer.resolve(type: ToggleBookmarkUseCase.self),
                itemFilterFactory: DIContainer.resolve(type: ItemFilterBottomSheetFactory.self),
                monsterFilterFactory: DIContainer.resolve(type: MonsterFilterBottomSheetFactory.self),
                sortedFactory: DIContainer.resolve(type: SortedBottomSheetFactory.self),
                bookmarkModalFactory: DIContainer.resolve(type: BookmarkModalFactory.self), detailFactory: DIContainer.resolve(type: DictionaryDetailFactory.self)
            )
        }
        DIContainer.register(type: DictionarySearchResultFactory.self) {
            DictionarySearchResultFactoryImpl(
                dictionaryMainListFactory: DIContainer
                    .resolve(type: DictionaryMainListFactory.self)
            )
        }
        DIContainer.register(type: DictionarySearchFactory.self) {
            DictionarySearchFactoryImpl(
                searchResultFactory: DIContainer
                    .resolve(type: DictionarySearchResultFactory.self)
            )
        }
        DIContainer.register(type: NotificationSettingFactory.self) {
            NotificationSettingFactoryImpl()
        }
        DIContainer.register(type: DictionaryNotificationFactory.self) {
            DictionaryNotificationFactoryImpl(
                fetchNotificationUseCase: DIContainer
                    .resolve(type: FetchNotificationUseCase.self),
                notificationSettingFactory: DIContainer
                    .resolve(type: NotificationSettingFactory.self)
            )
        }
        DIContainer.register(type: DictionaryMainViewFactory.self) {
            DictionaryMainViewFactoryImpl(
                dictionaryMainListFactory: DIContainer
                    .resolve(type: DictionaryMainListFactory.self),
                searchFactory: DIContainer.resolve(type: DictionarySearchFactory.self),
                notificationFactory: DIContainer
                    .resolve(type: DictionaryNotificationFactory.self)
            )
        }
        DIContainer.register(type: BookmarkOnBoardingFactory.self) {
            BookmarkOnBoardingFactoryImpl()
        }
        DIContainer.register(type: OnBoardingInputFactory.self) {
            OnBoardingInputFactoryImpl(
                checkEmptyUseCase: DIContainer
                    .resolve(type: CheckEmptyLevelAndRoleUseCase.self),
                checkValidLevelUseCase: DIContainer
                    .resolve(type: CheckValidLevelUseCase.self),
                fetchJobListUseCase: DIContainer
                    .resolve(type: FetchJobListUseCase.self),
                updateUserInfoUseCase: DIContainer
                    .resolve(type: UpdateUserInfoUseCase.self)
            )
        }
        DIContainer.register(type: OnBoardingQuestionFactory.self) {
            OnBoardingQuestionFactoryImpl(onBoardingInputFactory: DIContainer.resolve(type: OnBoardingInputFactory.self))
        }
        DIContainer.register(type: TermsAgreementFactory.self) {
            TermsAgreementFactoryImpl(
                onBoardingQuestionFactory: DIContainer
                    .resolve(type: OnBoardingQuestionFactory.self),
                signUpWithKakaoUseCase: DIContainer
                    .resolve(type: SignUpWithKakaoUseCase.self),
                signUpWithAppleUseCase: DIContainer
                    .resolve(type: SignUpWithAppleUseCase.self),
                saveTokenUseCase: DIContainer
                    .resolve(type: SaveTokenToLocalUseCase.self),
                fetchTokenUseCase: DIContainer
                    .resolve(type: FetchTokenFromLocalUseCase.self)
            )
        }
        DIContainer.register(type: PutFCMTokenUseCase.self) {
            PutFCMTokenUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: LoginFactory.self) {
            LoginFactoryImpl(
                termsAgreementsFactory: DIContainer
                    .resolve(type: TermsAgreementFactory.self),
                appleLoginUseCase: DIContainer
                    .resolve(type: FetchSocialCredentialUseCase.self, name: "apple"),
                kakaoLoginUseCase: DIContainer
                    .resolve(type: FetchSocialCredentialUseCase.self, name: "kakao"),
                loginWithAppleUseCase: DIContainer
                    .resolve(type: LoginWithAppleUseCase.self),
                loginWithKakaoUseCase: DIContainer
                    .resolve(type: LoginWithKakaoUseCase.self),
                fetchTokenUseCase: DIContainer.resolve(type: FetchTokenFromLocalUseCase.self),
                putFCMTokenUseCase: DIContainer.resolve(type: PutFCMTokenUseCase.self)
            )
        }
        DIContainer.register(type: BookmarkListFactory.self) {
            BookmarkListFactoryImpl(
                fetchDictionaryItemsUseCase: DIContainer
                    .resolve(type: FetchDictionaryItemsUseCase.self),
                toggleBookmarkUseCase: DIContainer
                    .resolve(type: ToggleBookmarkUseCase.self),
                itemFilterFactory: DIContainer
                    .resolve(type: ItemFilterBottomSheetFactory.self),
                monsterFilterFactory: DIContainer
                    .resolve(type: MonsterFilterBottomSheetFactory.self),
                sortedFactory: DIContainer
                    .resolve(type: SortedBottomSheetFactory.self),
                bookmarkModalFactory: DIContainer
                    .resolve(type: BookmarkModalFactory.self),
                checkLoginUseCase: DIContainer
                    .resolve(type: CheckLoginUseCase.self),
                loginFactory: DIContainer.resolve(type: LoginFactory.self)
            )
        }
        DIContainer.register(type: CollectionSettingFactory.self) {
            CollectionSettingFactoryImpl()
        }
        DIContainer.register(type: CollectionEditFactory.self) {
            CollectionEditFactoryImpl(toggleBookmarkUseCase: DIContainer.resolve(type: ToggleBookmarkUseCase.self), bookmarkModalFactory: DIContainer.resolve(type: BookmarkModalFactory.self))
        }
        DIContainer.register(type: CollectionDetailFactory.self) {
            CollectionDetailFactoryImpl(
                toggleBookmarkUseCase: DIContainer
                    .resolve(type: ToggleBookmarkUseCase.self),
                bookmarkModalFactory: DIContainer
                    .resolve(type: BookmarkModalFactory.self),
                collectionSettingFactory: DIContainer
                    .resolve(type: CollectionSettingFactory.self),
                addCollectionFactory: DIContainer
                    .resolve(type: AddCollectionFactory.self),
                collectionEditFactory: DIContainer
                    .resolve(type: CollectionEditFactory.self)
            )
        }
        DIContainer.register(type: CollectionListFactory.self) {
            CollectionListFactoryImpl(addCollectionFactory: DIContainer.resolve(type: AddCollectionFactory.self), bookmarkDetailFactory: DIContainer.resolve(type: CollectionDetailFactory.self))
        }
        DIContainer.register(type: BookmarkMainFactory.self) {
            BookmarkMainFactoryImpl(
                getOnBoardingUseCase: DIContainer
                    .resolve(type: GetBookmarkOnboardingUseCase.self),
                setOnBoardingUseCase: DIContainer
                    .resolve(type: SetBookmarkOnBoardingUseCase.self),
                onBoardingFactory: DIContainer
                    .resolve(type: BookmarkOnBoardingFactory.self),
                bookmarkListFactory: DIContainer
                    .resolve(type: BookmarkListFactory.self),
                collectionListFactory: DIContainer
                    .resolve(type: CollectionListFactory.self),
                searchFactory: DIContainer
                    .resolve(type: DictionarySearchFactory.self),
                notificationFactory: DIContainer.resolve(
                    type: DictionaryNotificationFactory.self
                )
            )
        }
    }
}
