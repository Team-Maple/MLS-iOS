// swiftlint:disable function_body_length
// swiftlint:disable line_length

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
        DIContainer.register(type: AuthAPIRepository.self) {
            AuthAPIRepositoryMock(provider: DIContainer.resolve(type: NetworkProvider.self))
        }
        DIContainer.register(type: TokenRepository.self) {
            KeyChainRepositoryImpl()
        }
        DIContainer.register(type: DictionaryListAPIRepository.self) {
            return DictionaryListAPIRepositoryImpl(provider: DIContainer.resolve(type: NetworkProvider.self), tokenInterceptor: TokenInterceptor(fetchTokenUseCase: DIContainer.resolve(type: FetchTokenFromLocalUseCase.self)))
        }
        DIContainer.register(type: BookmarkRepository.self) {
            return BookmarkRepositoryImpl(provider: DIContainer.resolve(type: NetworkProvider.self), interceptor: TokenInterceptor(fetchTokenUseCase: DIContainer.resolve(type: FetchTokenFromLocalUseCase.self)))
        }
        DIContainer.register(type: DictionaryDetailAPIRepository.self) {
            return DictionaryDetailAPIRepositoryImpl(provider: DIContainer.resolve(type: NetworkProvider.self), tokenInterceptor: TokenInterceptor(fetchTokenUseCase: DIContainer.resolve(type: FetchTokenFromLocalUseCase.self)))
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
        DIContainer.register(type: FetchNotificationUseCase.self) {
            FetchNotificationUseCaseImpl()
        }
        DIContainer.register(type: SetBookmarkUseCase.self) {
            SetBookmarkUseCaseImpl(repository: DIContainer.resolve(type: BookmarkRepository.self))
        }
        DIContainer.register(type: CheckLoginUseCase.self) {
            CheckLoginUseCaseImpl(authRepository: DIContainer.resolve(type: AuthAPIRepository.self), tokenRepository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: CheckNotificationPermissionUseCase.self) {
            return CheckNotificationPermissionUseCaseImpl()
        }
        DIContainer.register(type: OpenNotificationSettingUseCase.self) {
            return OpenNotificationSettingUseCaseImpl()
        }
        DIContainer.register(type: UpdateNotificationAgreementUseCase.self) {
            return UpdateNotificationAgreementUseCaseImpl(authRepository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: UpdateMarketingAgreementUseCase.self) {
            return UpdateMarketingAgreementUseCaseImpl(authRepository: DIContainer.resolve(type: AuthAPIRepository.self), tokenRepository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: FetchDictionaryMapListUseCase.self) {
            return FetchDictionaryMapListUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryItemListUseCase.self) {
            return FetchDictionaryItemListUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryQuestListUseCase.self) {
            return FetchDictionaryQuestListUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryNpcListUseCase.self) {
            return FetchDictionaryNpcListUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryMonsterListUseCase.self) {
            return FetchDictionaryMonsterListUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailMonsterUseCase.self) {
            return FetchDictionaryDetailMonsterUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailMonsterItemsUseCase.self) {
            return FetchDictionaryDetailMonsterDropItemUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailMonsterMapUseCase.self) {
            return FetchDictionaryDetailMonsterMapUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailNpcUseCase.self) {
            return FetchDictionaryDetailNpcUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailNpcQuestUseCase.self) {
            return FetchDictionaryDetailNpcQuestUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailNpcMapUseCase.self) {
            return FetchDictionaryDetailNpcMapUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailItemUseCase.self) {
            return FetchDictionaryDetailItemUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailItemDropMonsterUseCase.self) {
            return FetchDictionaryDetailItemDropMonsterUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailQuestUseCase.self) {
            return FetchDictionaryDetailQuestUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailQuestLinkedQuestsUseCase.self) {
            return FetchDictionaryDetailQuestLinkedQuestsUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailMapUseCase.self) {
            return FetchDictionaryDetailMapUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailMapSpawnMonsterUseCase.self) {
            return FetchDictionaryDetailMapSpawnMonsterUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionaryDetailMapNpcUseCase.self) {
            return FetchDictionaryDetailMapNpcUseCaseImpl(repository: DIContainer.resolve(type: DictionaryDetailAPIRepository.self))
        }
        DIContainer.register(type: FetchMonsterBookmarkUseCase.self) {
            FetchMonsterBookmarkUseCaseImpl(repository: DIContainer.resolve(type: BookmarkRepository.self))
        }
        DIContainer.register(type: FetchItemBookmarkUseCase.self) {
            FetchItemBookmarkUseCaseImpl(repository: DIContainer.resolve(type: BookmarkRepository.self))
        }
        DIContainer.register(type: FetchMapBookmarkUseCase.self) {
            FetchMapBookmarkUseCaseImpl(repository: DIContainer.resolve(type: BookmarkRepository.self))
        }
        DIContainer.register(type: FetchQuestBookmarkUseCase.self) {
            FetchQuestBookmarkUseCaseImpl(repository: DIContainer.resolve(type: BookmarkRepository.self))
        }
        DIContainer.register(type: FetchNPCBookmarkUseCase.self) {
            FetchNPCBookmarkUseCaseImpl(repository: DIContainer.resolve(type: BookmarkRepository.self))
        }
        DIContainer.register(type: FetchBookmarkUseCase.self) {
            FetchBookmarkUseCaseImpl(repository: DIContainer.resolve(type: BookmarkRepository.self))
        }
        DIContainer.register(type: FetchDictionaryAllListUseCase.self) {
            FetchDictionaryAllListUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: RecentSearchRemoveUseCase.self) {
            RecentSearchRemoveUseCaseImpl(repository: DIContainer.resolve(type: UserDefaultsRepository.self))
        }
        DIContainer.register(type: RecentSearchAddUseCase.self) {
            RecentSearchAddUseCaseImpl(repository: DIContainer.resolve(type: UserDefaultsRepository.self))
        }
        DIContainer.register(type: FetchDictionaryListCountUseCase.self) {
            FetchDictionaryListCountUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: FetchDictionarySearchListUseCase.self) {
            FetchDictionarySearchListUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListAPIRepository.self))
        }
        DIContainer.register(type: RecentSearchFetchUseCase.self) {
            RecentSearchFetchUseCaseImpl(repository: DIContainer.resolve(type: UserDefaultsRepository.self))
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
            return DictionaryDetailFactoryImpl(dictionaryDetailMapUseCase: DIContainer.resolve(type: FetchDictionaryDetailMapUseCase.self), dictionaryDetailMapSpawnMonsterUseCase: DIContainer.resolve(type: FetchDictionaryDetailMapSpawnMonsterUseCase.self), dictionaryDetailMapNpcUseCase: DIContainer.resolve(type: FetchDictionaryDetailMapNpcUseCase.self), dictionaryDetailQuestLinkedQuestsUseCase: DIContainer.resolve(type: FetchDictionaryDetailQuestLinkedQuestsUseCase.self), dictionaryDetailQuestUseCase: DIContainer.resolve(type: FetchDictionaryDetailQuestUseCase.self), dictionaryDetailItemDropMonsterUseCase: DIContainer.resolve(type: FetchDictionaryDetailItemDropMonsterUseCase.self), dictionaryDetailItemUseCase: DIContainer.resolve(type: FetchDictionaryDetailItemUseCase.self), dictionaryDetailNpcUseCase: DIContainer.resolve(type: FetchDictionaryDetailNpcUseCase.self), dictionaryDetailNpcQuestUseCase: DIContainer.resolve(type: FetchDictionaryDetailNpcQuestUseCase.self), dictionaryDetailNpcMapUseCase: DIContainer.resolve(type: FetchDictionaryDetailNpcMapUseCase.self), dictionaryDetailMonsterUseCase: DIContainer.resolve(type: FetchDictionaryDetailMonsterUseCase.self), dictionaryDetailMonsterDropItemUseCase: DIContainer.resolve(type: FetchDictionaryDetailMonsterItemsUseCase.self), dictionaryDetailMonsterMapUseCase: DIContainer.resolve(type: FetchDictionaryDetailMonsterMapUseCase.self))
        }
        DIContainer.register(type: DictionaryMainListFactory.self) {
            DictionaryListFactoryImpl(
                checkLoginUseCase: DIContainer.resolve(type: CheckLoginUseCase.self),
                dictionaryAllListItemUseCase: DIContainer.resolve(type: FetchDictionaryAllListUseCase.self),
                dictionaryMapListItemUseCase: DIContainer.resolve(type: FetchDictionaryMapListUseCase.self),
                dictionaryItemListItemUseCase: DIContainer.resolve(type: FetchDictionaryItemListUseCase.self),
                dictionaryQuestListItemUseCase: DIContainer.resolve(type: FetchDictionaryQuestListUseCase.self),
                dictionaryNpcListItemUseCase: DIContainer.resolve(type: FetchDictionaryNpcListUseCase.self),
                dictionaryListItemUseCase: DIContainer.resolve(type: FetchDictionaryMonsterListUseCase.self),
                setBookmarkUseCase: DIContainer.resolve(type: SetBookmarkUseCase.self),
                itemFilterFactory: DIContainer.resolve(type: ItemFilterBottomSheetFactory.self),
                monsterFilterFactory: DIContainer.resolve(type: MonsterFilterBottomSheetFactory.self),
                sortedFactory: DIContainer.resolve(type: SortedBottomSheetFactory.self),
                bookmarkModalFactory: DIContainer.resolve(type: BookmarkModalFactory.self),
                detailFactory: DIContainer.resolve(type: DictionaryDetailFactory.self)
            )
        }
        DIContainer.register(type: DictionarySearchResultFactory.self) {
            DictionarySearchResultFactoryImpl(
                dictionaryListCountUseCase: DIContainer.resolve(type: FetchDictionaryListCountUseCase.self),
                dictionaryMainListFactory: DIContainer
                    .resolve(type: DictionaryMainListFactory.self),
                dictionarySearchListUseCase: DIContainer.resolve(type: FetchDictionarySearchListUseCase.self)
            )
        }
        DIContainer.register(type: DictionarySearchFactory.self) {
            DictionarySearchFactoryImpl(recentSearchRemoveUseCase: DIContainer.resolve(type: RecentSearchRemoveUseCase.self),
                recentSearchAddUseCase: DIContainer.resolve(type: RecentSearchAddUseCase.self),
                searchResultFactory: DIContainer
                .resolve(type: DictionarySearchResultFactory.self), recentSearchFetchUseCase: DIContainer.resolve(type: RecentSearchFetchUseCase.self)
            )
        }
        DIContainer.register(type: NotificationSettingFactory.self) {
            NotificationSettingFactoryImpl(checkNotificationPermissionUseCase: DIContainer.resolve(type: CheckNotificationPermissionUseCase.self), updateNotificationAgreementUseCase: DIContainer.resolve(type: UpdateNotificationAgreementUseCase.self))
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
                    .resolve(type: DictionaryNotificationFactory.self), checkLoginUseCase: DIContainer.resolve(type: CheckLoginUseCase.self))
        }
        DIContainer.register(type: BookmarkOnBoardingFactory.self) {
            BookmarkOnBoardingFactoryImpl()
        }
        DIContainer.register(type: OnBoardingNotificationSheetFactory.self) {
            return OnBoardingNotificationSheetFactoryImpl(checkNotificationPermissionUseCase: DIContainer.resolve(type: CheckNotificationPermissionUseCase.self), openNotificationSettingUseCase: DIContainer.resolve(type: OpenNotificationSettingUseCase.self), updateNotificationAgreementUseCase: DIContainer.resolve(type: UpdateNotificationAgreementUseCase.self), updateUserInfoUseCase: DIContainer.resolve(type: UpdateUserInfoUseCase.self), dictionaryMainViewFactory: DIContainer.resolve(type: DictionaryMainViewFactory.self))
        }
        DIContainer.register(type: OnBoardingNotificationFactory.self) {
            return OnBoardingNotificationFactoryImpl(onBoardingNotificationSheetFactory: DIContainer.resolve(type: OnBoardingNotificationSheetFactory.self))
        }
        DIContainer.register(type: OnBoardingInputFactory.self) {
            return OnBoardingInputFactoryImpl(
                checkEmptyUseCase: DIContainer
                    .resolve(type: CheckEmptyLevelAndRoleUseCase.self),
                checkValidLevelUseCase: DIContainer
                    .resolve(type: CheckValidLevelUseCase.self),
                fetchJobListUseCase: DIContainer
                    .resolve(type: FetchJobListUseCase.self), updateUserInfoUseCase: DIContainer.resolve(type: UpdateUserInfoUseCase.self),
                onBoardingNotificationFactory: DIContainer
                    .resolve(type: OnBoardingNotificationFactory.self)
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
                    .resolve(type: FetchTokenFromLocalUseCase.self), updateMarketingAgreementUseCase: DIContainer.resolve(type: UpdateMarketingAgreementUseCase.self)
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
            BookmarkListFactoryImpl(itemFilterFactory: DIContainer.resolve(type: ItemFilterBottomSheetFactory.self), monsterFilterFactory: DIContainer.resolve(type: MonsterFilterBottomSheetFactory.self), sortedFactory: DIContainer.resolve(type: SortedBottomSheetFactory.self), bookmarkModalFactory: DIContainer.resolve(type: BookmarkModalFactory.self), loginFactory: DIContainer.resolve(type: LoginFactory.self), dictionaryDetailFactory: DIContainer.resolve(type: DictionaryDetailFactory.self), setBookmarkUseCase: DIContainer.resolve(type: SetBookmarkUseCase.self), checkLoginUseCase: DIContainer.resolve(type: CheckLoginUseCase.self), fetchBookmarkUseCase: DIContainer.resolve(type: FetchBookmarkUseCase.self), fetchMonsterBookmarkUseCase: DIContainer.resolve(type: FetchMonsterBookmarkUseCase.self), fetchItemBookmarkUseCase: DIContainer.resolve(type: FetchItemBookmarkUseCase.self), fetchNPCBookmarkUseCase: DIContainer.resolve(type: FetchNPCBookmarkUseCase.self), fetchQuestBookmarkUseCase: DIContainer.resolve(type: FetchQuestBookmarkUseCase.self), fetchMapBookmarkUseCase: DIContainer.resolve(type: FetchMapBookmarkUseCase.self))
        }
        DIContainer.register(type: CollectionSettingFactory.self) {
            CollectionSettingFactoryImpl()
        }
        DIContainer.register(type: CollectionEditFactory.self) {
            CollectionEditFactoryImpl(setBookmarkUseCase: DIContainer.resolve(type: SetBookmarkUseCase.self), bookmarkModalFactory: DIContainer.resolve(type: BookmarkModalFactory.self))
        }
        DIContainer.register(type: CollectionDetailFactory.self) {
            CollectionDetailFactoryImpl(
                setBookmarkUseCase: DIContainer
                    .resolve(type: SetBookmarkUseCase.self),
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
                setBookmarkUseCase: DIContainer
                    .resolve(type: SetBookmarkUseCase.self),
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
