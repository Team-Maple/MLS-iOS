// swiftlint:disable function_body_length
// swiftlint:disable file_length

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
import Firebase
import KakaoSDKCommon
import MyPageFeature
import MyPageFeatureInterface
import os
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        // MARK: - UserNotification Set
        FirebaseApp.configure() // Firebase Set
        Messaging.messaging().delegate = self // 파이어베이스 Meesaging 설정
        UNUserNotificationCenter.current().delegate = self // NotificationCenter Delegate

        // MARK: - Modules Set
        ImageLoader.shared.configure.diskCacheCountLimit = 10 // ImageLoader
        FontManager.registerFonts() // FontManager

        // MARK: - KakaoSDK Set
        let kakaoNativeAppKey: String =
            Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)

        registerDependencies()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}

// MARK: - Notification Delegate, MessagingDelegate
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        completionHandler([.list, .banner])
    }

    // 파이어베이스 MessagingDelegate 설정
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        guard let fcmToken = fcmToken else {
            os_log("FCM token is nil")
            return
        }

        let saveTokenUseCase = DIContainer.resolve(type: SaveTokenToLocalUseCase.self)
        let saveResult = saveTokenUseCase.execute(type: .fcmToken, value: fcmToken)

        switch saveResult {
        case .success:
            os_log("fcmToken Save Success: \(fcmToken)")
        case .failure:
            os_log("fcmToken Save Failure")
        }

        let fetchTokenUseCase = DIContainer.resolve(type: FetchTokenFromLocalUseCase.self)
        let putFCMTokenUseCase = DIContainer.resolve(type: PutFCMTokenUseCase.self)

        if case .success(let accessToken) = fetchTokenUseCase.execute(type: .accessToken),
           !accessToken.isEmpty {
            _ = putFCMTokenUseCase.execute(fcmToken: fcmToken)
            os_log("Request to update FCM token on server")
        } else {
            os_log("Not logged in yet, skipping FCM update to server")
        }
    }
}

// MARK: - registerDependencies
private extension AppDelegate {
    func registerDependencies() {
        registerProvider()
        registerRepository()
        registerUseCase()
        registerFactory()

        DIContainer.register(type: AppCoordinatorProtocol.self) {
            AppCoordinator(
                window: nil,
                dictionaryMainViewFactory: DIContainer.resolve(
                    type: DictionaryMainViewFactory.self
                ),
                bookmarkMainFactory: DIContainer.resolve(
                    type: BookmarkMainFactory.self
                ),
                myPageMainFactory: DIContainer.resolve(
                    type: MyPageMainFactory.self
                ),
                loginFactory: DIContainer.resolve(type: LoginFactory.self)
            )
        }
    }

    func registerProvider() {
        DIContainer.register(type: NetworkProvider.self) {
            NetworkProviderImpl()
        }
        DIContainer.register(
            type: SocialAuthenticatableProvider.self,
            name: "kakao"
        ) {
            KakaoLoginProviderImpl()
        }
        DIContainer.register(
            type: SocialAuthenticatableProvider.self,
            name: "apple"
        ) {
            AppleLoginProviderImpl()
        }
        DIContainer.register(type: Interceptor.self, name: "tokenInterceptor") {
            TokenInterceptor(
                fetchTokenUseCase: DIContainer.resolve(
                    type: FetchTokenFromLocalUseCase.self
                )
            )
        }

        DIContainer.register(type: Interceptor.self, name: "authInterceptor") {
            AuthInterceptor(tokenRepository: DIContainer.resolve(type: TokenRepository.self), authRepository: { DIContainer.resolve(type: AuthAPIRepository.self) })
        }
    }

    func registerRepository() {
        DIContainer.register(type: AuthAPIRepository.self) {
            AuthAPIRepositoryImpl(
                provider: DIContainer.resolve(type: NetworkProvider.self),
                tokenInterceptor: DIContainer.resolve(type: Interceptor.self, name: "tokenInterceptor"),
                authInterceptor: DIContainer.resolve(type: Interceptor.self, name: "authInterceptor")
            )
        }
        DIContainer.register(type: TokenRepository.self) {
            KeyChainRepositoryImpl()
        }
        DIContainer.register(type: DictionaryDetailAPIRepository.self) {
            DictionaryDetailAPIRepositoryImpl(
                provider: DIContainer.resolve(type: NetworkProvider.self),
                tokenInterceptor: DIContainer.resolve(type: Interceptor.self, name: "tokenInterceptor")
            )
        }
        DIContainer.register(type: DictionaryListAPIRepository.self) {
            DictionaryListAPIRepositoryImpl(
                provider: DIContainer.resolve(type: NetworkProvider.self),
                tokenInterceptor: DIContainer.resolve(type: Interceptor.self, name: "tokenInterceptor")
            )
        }
        DIContainer.register(type: BookmarkRepository.self) {
            BookmarkRepositoryImpl(
                provider: DIContainer.resolve(type: NetworkProvider.self),
                interceptor: DIContainer.resolve(type: Interceptor.self, name: "tokenInterceptor")
            )
        }
        DIContainer.register(type: UserDefaultsRepository.self) {
            UserDefaultsRepositoryImpl()
        }
        DIContainer.register(type: AlarmAPIRepository.self) {
            AlarmAPIRepositoryImpl(
                provider: DIContainer.resolve(type: NetworkProvider.self),
                interceptor: DIContainer.resolve(type: Interceptor.self, name: "tokenInterceptor")
            )
        }
        DIContainer.register(type: CollectionAPIRepository.self) {
            CollectionAPIRepositoryImpl(
                provider: DIContainer.resolve(type: NetworkProvider.self),
                tokenInterceptor: DIContainer.resolve(type: Interceptor.self, name: "tokenInterceptor")
            )
        }
    }

    func registerUseCase() {
        DIContainer.register(
            type: FetchSocialCredentialUseCase.self,
            name: "kakao"
        ) {
            let provider = DIContainer.resolve(
                type: SocialAuthenticatableProvider.self,
                name: "kakao"
            )
            return SocialLoginUseCaseImpl(provider: provider)
        }
        DIContainer.register(
            type: FetchSocialCredentialUseCase.self,
            name: "apple"
        ) {
            let provider = DIContainer.resolve(
                type: SocialAuthenticatableProvider.self,
                name: "apple"
            )
            return SocialLoginUseCaseImpl(provider: provider)
        }
        DIContainer.register(type: CheckEmptyLevelAndRoleUseCase.self) {
            CheckEmptyLevelAndRoleUseCaseImpl()
        }
        DIContainer.register(type: CheckValidLevelUseCase.self) {
            CheckValidLevelUseCaseImpl()
        }
        DIContainer.register(type: FetchJobListUseCase.self) {
            FetchJobListUseCaseImpl(
                repository: DIContainer.resolve(type: AuthAPIRepository.self)
            )
        }
        DIContainer.register(type: LoginWithAppleUseCase.self) {
            LoginWithAppleUseCaseImpl(
                authRepository: DIContainer.resolve(
                    type: AuthAPIRepository.self
                ),
                tokenRepository: DIContainer.resolve(
                    type: TokenRepository.self
                ),
                userDefaultsRepository: DIContainer.resolve(
                    type: UserDefaultsRepository.self
                )
            )
        }
        DIContainer.register(type: LoginWithKakaoUseCase.self) {
            LoginWithKakaoUseCaseImpl(
                authRepository: DIContainer.resolve(
                    type: AuthAPIRepository.self
                ),
                tokenRepository: DIContainer.resolve(
                    type: TokenRepository.self
                ),
                userDefaultsRepository: DIContainer.resolve(
                    type: UserDefaultsRepository.self
                )
            )
        }
        DIContainer.register(type: SignUpWithAppleUseCase.self) {
            SignUpWithAppleUseCaseImpl(
                authRepository: DIContainer.resolve(type: AuthAPIRepository.self),
                tokenRepository: DIContainer.resolve(type: TokenRepository.self),
                userDefaultsRepository: DIContainer.resolve(type: UserDefaultsRepository.self)
            )
        }
        DIContainer.register(type: SignUpWithKakaoUseCase.self) {
            SignUpWithKakaoUseCaseImpl(
                authRepository: DIContainer.resolve(type: AuthAPIRepository.self),
                tokenRepository: DIContainer.resolve(type: TokenRepository.self),
                userDefaultsRepository: DIContainer.resolve(type: UserDefaultsRepository.self)
            )
        }
        DIContainer.register(type: UpdateUserInfoUseCase.self) {
            UpdateUserInfoUseCaseImpl(
                repository: DIContainer.resolve(type: AuthAPIRepository.self)
            )
        }
        DIContainer.register(type: ReissueUseCase.self) {
            ReissueUseCaseImpl(
                repository: DIContainer.resolve(type: AuthAPIRepository.self), tokenRepository: DIContainer.resolve(type: TokenRepository.self)
            )
        }
        DIContainer.register(type: PutFCMTokenUseCase.self) {
            PutFCMTokenUseCaseImpl(
                repository: DIContainer.resolve(type: AuthAPIRepository.self)
            )
        }
        DIContainer.register(type: FetchTokenFromLocalUseCase.self) {
            FetchTokenFromLocalUseCaseImpl(
                repository: DIContainer.resolve(type: TokenRepository.self)
            )
        }
        DIContainer.register(type: SaveTokenToLocalUseCase.self) {
            SaveTokenToLocalUseCaseImpl(
                repository: DIContainer.resolve(type: TokenRepository.self)
            )
        }
        DIContainer.register(type: DeleteTokenFromLocalUseCase.self) {
            DeleteTokenFromLocalUseCaseImpl(
                repository: DIContainer.resolve(type: TokenRepository.self)
            )
        }
        DIContainer.register(type: UpdateMarketingAgreementUseCase.self) {
            UpdateMarketingAgreementUseCaseImpl(
                authRepository: DIContainer.resolve(
                    type: AuthAPIRepository.self
                ),
                tokenRepository: DIContainer.resolve(type: TokenRepository.self)
            )
        }
        DIContainer.register(type: CheckNotificationPermissionUseCase.self) {
            CheckNotificationPermissionUseCaseImpl()
        }
        DIContainer.register(type: OpenNotificationSettingUseCase.self) {
            OpenNotificationSettingUseCaseImpl()
        }
        DIContainer.register(type: UpdateNotificationAgreementUseCase.self) {
            UpdateNotificationAgreementUseCaseImpl(
                authRepository: DIContainer.resolve(
                    type: AuthAPIRepository.self
                )
            )
        }
        DIContainer.register(type: CheckLoginUseCase.self) {
            CheckLoginUseCaseImpl(
                authRepository: DIContainer.resolve(
                    type: AuthAPIRepository.self
                ),
                tokenRepository: DIContainer.resolve(type: TokenRepository.self)
            )
        }
        DIContainer.register(type: FetchDictionaryAllListUseCase.self) {
            FetchDictionaryAllListUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryListAPIRepository.self
                )
            )
        }
        DIContainer.register(type: SetBookmarkUseCase.self) {
            SetBookmarkUseCaseImpl(
                repository: DIContainer.resolve(type: BookmarkRepository.self)
            )
        }
        DIContainer.register(type: FetchPlatformUseCase.self) {
            FetchPlatformUseCaseImpl(
                repository: DIContainer.resolve(
                    type: UserDefaultsRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryMapListUseCase.self) {
            FetchDictionaryMapListUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryListAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryItemListUseCase.self) {
            FetchDictionaryItemListUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryListAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryQuestListUseCase.self) {
            FetchDictionaryQuestListUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryListAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryNpcListUseCase.self) {
            FetchDictionaryNpcListUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryListAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryMonsterListUseCase.self) {
            FetchDictionaryMonsterListUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryListAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryDetailMonsterUseCase.self) {
            FetchDictionaryDetailMonsterUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(
            type: FetchDictionaryDetailMonsterItemsUseCase.self
        ) {
            FetchDictionaryDetailMonsterDropItemUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryDetailMonsterMapUseCase.self) {
            FetchDictionaryDetailMonsterMapUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryDetailNpcUseCase.self) {
            FetchDictionaryDetailNpcUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryDetailNpcQuestUseCase.self) {
            FetchDictionaryDetailNpcQuestUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryDetailNpcMapUseCase.self) {
            FetchDictionaryDetailNpcMapUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryDetailItemUseCase.self) {
            FetchDictionaryDetailItemUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(
            type: FetchDictionaryDetailItemDropMonsterUseCase.self
        ) {
            FetchDictionaryDetailItemDropMonsterUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryDetailQuestUseCase.self) {
            FetchDictionaryDetailQuestUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(
            type: FetchDictionaryDetailQuestLinkedQuestsUseCase.self
        ) {
            FetchDictionaryDetailQuestLinkedQuestsUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryDetailMapUseCase.self) {
            FetchDictionaryDetailMapUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(
            type: FetchDictionaryDetailMapSpawnMonsterUseCase.self
        ) {
            FetchDictionaryDetailMapSpawnMonsterUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryDetailMapNpcUseCase.self) {
            FetchDictionaryDetailMapNpcUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryDetailAPIRepository.self
                )
            )
        }
        DIContainer.register(type: RecentSearchRemoveUseCase.self) {
            RecentSearchRemoveUseCaseImpl(
                repository: DIContainer.resolve(
                    type: UserDefaultsRepository.self
                )
            )
        }
        DIContainer.register(type: RecentSearchAddUseCase.self) {
            RecentSearchAddUseCaseImpl(
                repository: DIContainer.resolve(
                    type: UserDefaultsRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionaryListCountUseCase.self) {
            FetchDictionaryListCountUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryListAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchDictionarySearchListUseCase.self) {
            FetchDictionarySearchListUseCaseImpl(
                repository: DIContainer.resolve(
                    type: DictionaryListAPIRepository.self
                )
            )
        }
        DIContainer.register(type: RecentSearchFetchUseCase.self) {
            RecentSearchFetchUseCaseImpl(
                repository: DIContainer.resolve(
                    type: UserDefaultsRepository.self
                )
            )
        }
        DIContainer.register(type: FetchBookmarkUseCase.self) {
            FetchBookmarkUseCaseImpl(
                repository: DIContainer.resolve(type: BookmarkRepository.self)
            )
        }
        DIContainer.register(type: FetchMonsterBookmarkUseCase.self) {
            FetchMonsterBookmarkUseCaseImpl(
                repository: DIContainer.resolve(type: BookmarkRepository.self)
            )
        }
        DIContainer.register(type: FetchItemBookmarkUseCase.self) {
            FetchItemBookmarkUseCaseImpl(
                repository: DIContainer.resolve(type: BookmarkRepository.self)
            )
        }
        DIContainer.register(type: FetchNPCBookmarkUseCase.self) {
            FetchNPCBookmarkUseCaseImpl(
                repository: DIContainer.resolve(type: BookmarkRepository.self)
            )
        }
        DIContainer.register(type: FetchQuestBookmarkUseCase.self) {
            FetchQuestBookmarkUseCaseImpl(
                repository: DIContainer.resolve(type: BookmarkRepository.self)
            )
        }
        DIContainer.register(type: FetchMapBookmarkUseCase.self) {
            FetchMapBookmarkUseCaseImpl(
                repository: DIContainer.resolve(type: BookmarkRepository.self)
            )
        }
        DIContainer.register(type: UpdateProfileImageUseCase.self) {
            UpdateProfileImageUseCaseImpl(
                repository: DIContainer.resolve(type: AuthAPIRepository.self)
            )
        }
        DIContainer.register(type: FetchJobUseCase.self) {
            FetchJobUseCaseImpl(
                repository: DIContainer.resolve(type: AuthAPIRepository.self)
            )
        }
        DIContainer.register(type: FetchProfileUseCase.self) {
            FetchProfileUseCaseImpl(
                repository: DIContainer.resolve(type: AuthAPIRepository.self),
                fetchJobUseCase: DIContainer.resolve(type: FetchJobUseCase.self)
            )
        }
        DIContainer.register(type: CheckNickNameUseCase.self) {
            CheckNickNameUseCaseImpl()
        }
        DIContainer.register(type: UpdateNickNameUseCase.self) {
            UpdateNickNameUseCaseImpl(
                repository: DIContainer.resolve(type: AuthAPIRepository.self)
            )
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
        DIContainer.register(type: FetchNoticesUseCase.self) {
            FetchNoticesUseCaseImpl(
                repository: DIContainer.resolve(type: AlarmAPIRepository.self)
            )
        }
        DIContainer.register(type: FetchOngoingEventsUseCase.self) {
            FetchOngoingEventsUseCaseImpl(
                repository: DIContainer.resolve(type: AlarmAPIRepository.self)
            )
        }
        DIContainer.register(type: FetchOutdatedEventsUseCase.self) {
            FetchOutdatedEventsUseCaseImpl(
                repository: DIContainer.resolve(type: AlarmAPIRepository.self)
            )
        }
        DIContainer.register(type: FetchPatchNotesUseCase.self) {
            FetchPatchNotesUseCaseImpl(
                repository: DIContainer.resolve(type: AlarmAPIRepository.self)
            )
        }
        DIContainer.register(type: SetReadUseCase.self) {
            SetReadUseCaseImpl(
                repository: DIContainer.resolve(type: AlarmAPIRepository.self)
            )
        }
        DIContainer.register(type: FetchAllAlarmUseCase.self) {
            FetchAllAlarmUseCaseImpl(
                repository: DIContainer.resolve(type: AlarmAPIRepository.self)
            )
        }
        DIContainer.register(type: ParseItemFilterResultUseCase.self) {
            ParseItemFilterResultUseCaseImpl()
        }
        DIContainer.register(type: FetchCollectionListUseCase.self) {
            FetchCollectionListUseCaseImpl(
                repository: DIContainer.resolve(
                    type: CollectionAPIRepository.self
                )
            )
        }
        DIContainer.register(type: CreateCollectionListUseCase.self) {
            CreateCollectionListUseCaseImpl(
                repository: DIContainer.resolve(
                    type: CollectionAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchCollectionUseCase.self) {
            FetchCollectionUseCaseImpl(
                repository: DIContainer.resolve(
                    type: CollectionAPIRepository.self
                )
            )
        }
        DIContainer.register(type: UpdateCollectionUseCase.self) {
            UpdateCollectionUseCaseImpl(
                repository: DIContainer.resolve(
                    type: CollectionAPIRepository.self
                )
            )
        }
        DIContainer.register(type: DeleteCollectionUseCase.self) {
            DeleteCollectionUseCaseImpl(
                repository: DIContainer.resolve(
                    type: CollectionAPIRepository.self
                )
            )
        }
        DIContainer.register(type: AddCollectionAndBookmarkUseCase.self) {
            AddCollectionAndBookmarkUseCaseImpl(
                repository: DIContainer.resolve(
                    type: CollectionAPIRepository.self
                )
            )
        }
        DIContainer.register(type: FetchVisitBookmarkUseCase.self) {
            FetchVisitBookmarkUseCaseImpl(
                repository: DIContainer.resolve(
                    type: UserDefaultsRepository.self
                )
            )
        }
        DIContainer.register(type: FetchVisitDictionaryDetailUseCase.self) {
            FetchVisitDictionaryDetailUseCaseImpl(repository: DIContainer.resolve(type: UserDefaultsRepository.self))
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
            AddCollectionFactoryImpl(
                createCollectionListUseCase: DIContainer.resolve(
                    type: CreateCollectionListUseCase.self
                ),
                setCollectionUseCase: DIContainer.resolve(
                    type: UpdateCollectionUseCase.self
                )
            )
        }
        DIContainer.register(type: BookmarkModalFactory.self) {
            BookmarkModalFactoryImpl(
                addCollectionFactory: DIContainer.resolve(
                    type: AddCollectionFactory.self
                ),
                fetchCollectionListUseCase: DIContainer.resolve(
                    type: FetchCollectionListUseCase.self
                ),
                addCollectionAndBookmarkUseCase: DIContainer.resolve(
                    type: AddCollectionAndBookmarkUseCase.self
                )
            )
        }
        DIContainer.register(type: LoginFactory.self) {
            LoginFactoryImpl(
                termsAgreementsFactory: DIContainer.resolve(
                    type: TermsAgreementFactory.self
                ),
                appleLoginUseCase: DIContainer.resolve(
                    type: FetchSocialCredentialUseCase.self,
                    name: "apple"
                ),
                kakaoLoginUseCase: DIContainer.resolve(
                    type: FetchSocialCredentialUseCase.self,
                    name: "kakao"
                ),
                loginWithAppleUseCase: DIContainer.resolve(
                    type: LoginWithAppleUseCase.self
                ),
                loginWithKakaoUseCase: DIContainer.resolve(
                    type: LoginWithKakaoUseCase.self
                ),
                fetchTokenUseCase: DIContainer.resolve(
                    type: FetchTokenFromLocalUseCase.self
                ),
                putFCMTokenUseCase: DIContainer.resolve(
                    type: PutFCMTokenUseCase.self
                ),
                fetchPlatformUseCase: DIContainer.resolve(
                    type: FetchPlatformUseCase.self
                )
            )
        }
        DIContainer.register(type: DictionaryDetailFactory.self) {
            DictionaryDetailFactoryImpl(
                loginFactory: { DIContainer.resolve(type: LoginFactory.self) },
                bookmarkModalFactory: DIContainer.resolve(
                    type: BookmarkModalFactory.self
                ),
                dictionaryDetailFactory: {
                    DIContainer
                        .resolve(type: DictionaryDetailFactory.self)
                },
                detailOnBoardingFactory: DIContainer.resolve(
                    type: DetailOnBoardingFactory.self
                ),
                appCoordinator: {
                    DIContainer.resolve(type: AppCoordinatorProtocol.self)
                },
                dictionaryDetailMapUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailMapUseCase.self
                ),
                dictionaryDetailMapSpawnMonsterUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailMapSpawnMonsterUseCase.self
                ),
                dictionaryDetailMapNpcUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailMapNpcUseCase.self
                ),
                dictionaryDetailQuestLinkedQuestsUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailQuestLinkedQuestsUseCase.self
                ),
                dictionaryDetailQuestUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailQuestUseCase.self
                ),
                dictionaryDetailItemDropMonsterUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailItemDropMonsterUseCase.self
                ),
                dictionaryDetailItemUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailItemUseCase.self
                ),
                dictionaryDetailNpcUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailNpcUseCase.self
                ),
                dictionaryDetailNpcQuestUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailNpcQuestUseCase.self
                ),
                dictionaryDetailNpcMapUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailNpcMapUseCase.self
                ),
                dictionaryDetailMonsterUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailMonsterUseCase.self
                ),
                dictionaryDetailMonsterDropItemUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailMonsterItemsUseCase.self
                ),
                dictionaryDetailMonsterMapUseCase: DIContainer.resolve(
                    type: FetchDictionaryDetailMonsterMapUseCase.self
                ),
                checkLoginUseCase: DIContainer.resolve(
                    type: CheckLoginUseCase.self
                ),
                setBookmarkUseCase: DIContainer.resolve(
                    type: SetBookmarkUseCase.self
                ),
                fetchVisitDictionaryDetailUseCase: DIContainer.resolve(
                    type: FetchVisitDictionaryDetailUseCase.self
                )
            )
        }
        DIContainer.register(type: DictionaryMainListFactory.self) {
            DictionaryListFactoryImpl(
                checkLoginUseCase: DIContainer.resolve(
                    type: CheckLoginUseCase.self
                ),
                dictionaryAllListItemUseCase: DIContainer.resolve(
                    type: FetchDictionaryAllListUseCase.self
                ),
                dictionaryMapListItemUseCase: DIContainer.resolve(
                    type: FetchDictionaryMapListUseCase.self
                ),
                dictionaryItemListItemUseCase: DIContainer.resolve(
                    type: FetchDictionaryItemListUseCase.self
                ),
                dictionaryQuestListItemUseCase: DIContainer.resolve(
                    type: FetchDictionaryQuestListUseCase.self
                ),
                dictionaryNpcListItemUseCase:
                DIContainer
                    .resolve(type: FetchDictionaryNpcListUseCase.self),
                dictionaryListItemUseCase: DIContainer.resolve(
                    type: FetchDictionaryMonsterListUseCase.self
                ),
                setBookmarkUseCase: DIContainer.resolve(
                    type: SetBookmarkUseCase.self
                ),
                parseItemFilterResultUseCase: DIContainer.resolve(
                    type: ParseItemFilterResultUseCase.self
                ),
                itemFilterFactory: DIContainer.resolve(
                    type: ItemFilterBottomSheetFactory.self
                ),
                monsterFilterFactory: DIContainer.resolve(
                    type: MonsterFilterBottomSheetFactory.self
                ),
                sortedFactory: DIContainer.resolve(
                    type: SortedBottomSheetFactory.self
                ),
                bookmarkModalFactory: DIContainer.resolve(
                    type: BookmarkModalFactory.self
                ),
                detailFactory: DIContainer.resolve(
                    type: DictionaryDetailFactory.self
                ),
                loginFactory: { DIContainer.resolve(type: LoginFactory.self) }
            )
        }
        DIContainer.register(type: DictionarySearchResultFactory.self) {
            DictionarySearchResultFactoryImpl(
                dictionaryListCountUseCase: DIContainer.resolve(
                    type: FetchDictionaryListCountUseCase.self
                ),
                dictionaryMainListFactory:
                DIContainer
                    .resolve(type: DictionaryMainListFactory.self),
                dictionarySearchListUseCase: DIContainer.resolve(
                    type: FetchDictionarySearchListUseCase.self
                ), recentSearchAddUseCase: DIContainer.resolve(
                    type: RecentSearchAddUseCase.self)
            )
        }
        DIContainer.register(type: DictionarySearchFactory.self) {
            DictionarySearchFactoryImpl(
                recentSearchRemoveUseCase: DIContainer.resolve(
                    type: RecentSearchRemoveUseCase.self
                ),
                recentSearchAddUseCase: DIContainer.resolve(
                    type: RecentSearchAddUseCase.self
                ),
                searchResultFactory:
                DIContainer
                    .resolve(type: DictionarySearchResultFactory.self),
                recentSearchFetchUseCase: DIContainer.resolve(
                    type: RecentSearchFetchUseCase.self
                )
            )
        }
        DIContainer.register(type: NotificationSettingFactory.self) {
            NotificationSettingFactoryImpl(
                checkNotificationPermissionUseCase: DIContainer.resolve(
                    type: CheckNotificationPermissionUseCase.self
                ),
                updateNotificationAgreementUseCase: DIContainer.resolve(
                    type: UpdateNotificationAgreementUseCase.self
                )
            )
        }
        DIContainer.register(type: DictionaryNotificationFactory.self) {
            DictionaryNotificationFactoryImpl(
                notificationSettingFactory: DIContainer.resolve(
                    type: NotificationSettingFactory.self
                ),
                fetchAllAlarmUseCase: DIContainer.resolve(
                    type: FetchAllAlarmUseCase.self
                ),
                fetchProfileUseCase: DIContainer.resolve(
                    type: FetchProfileUseCase.self
                ), checkNotificationPermissionUseCase: DIContainer.resolve(type: CheckNotificationPermissionUseCase.self),
                setReadUseCase: DIContainer.resolve(
                    type: SetReadUseCase.self)
            )
        }
        DIContainer.register(type: DictionaryMainViewFactory.self) {
            DictionaryMainViewFactoryImpl(
                dictionaryMainListFactory: DIContainer.resolve(
                    type: DictionaryMainListFactory.self
                ),
                searchFactory: DIContainer.resolve(
                    type: DictionarySearchFactory.self
                ),
                notificationFactory: DIContainer.resolve(
                    type: DictionaryNotificationFactory.self
                ),
                loginFactory: DIContainer.resolve(type: LoginFactory.self),
                fetchProfileUseCase: DIContainer.resolve(
                    type: FetchProfileUseCase.self
                )
            )
        }
        DIContainer.register(type: OnBoardingNotificationSheetFactory.self) {
            OnBoardingNotificationSheetFactoryImpl(
                checkNotificationPermissionUseCase:
                DIContainer
                    .resolve(type: CheckNotificationPermissionUseCase.self),
                openNotificationSettingUseCase:
                DIContainer
                    .resolve(type: OpenNotificationSettingUseCase.self),
                updateNotificationAgreementUseCase:
                DIContainer
                    .resolve(type: UpdateNotificationAgreementUseCase.self),
                updateUserInfoUseCase: DIContainer.resolve(
                    type: UpdateUserInfoUseCase.self
                ),
                appCoordinator: {
                    DIContainer.resolve(
                        type: AppCoordinatorProtocol.self
                    )
                }
            )
        }
        DIContainer.register(type: OnBoardingInputFactory.self) {
            OnBoardingInputFactoryImpl(
                checkEmptyUseCase: DIContainer.resolve(
                    type: CheckEmptyLevelAndRoleUseCase.self
                ),
                checkValidLevelUseCase: DIContainer.resolve(
                    type: CheckValidLevelUseCase.self
                ),
                fetchJobListUseCase: DIContainer.resolve(
                    type: FetchJobListUseCase.self
                ),
                updateUserInfoUseCase: DIContainer.resolve(
                    type: UpdateUserInfoUseCase.self
                ),
                onBoardingNotificationFactory: DIContainer.resolve(
                    type: OnBoardingNotificationFactory.self
                ),
                appCoordinator: {
                    DIContainer.resolve(type: AppCoordinatorProtocol.self)
                }
            )
        }
        DIContainer.register(type: OnBoardingQuestionFactory.self) {
            OnBoardingQuestionFactoryImpl(
                onBoardingInputFactory: DIContainer.resolve(
                    type: OnBoardingInputFactory.self
                )
            )
        }
        DIContainer.register(type: TermsAgreementFactory.self) {
            TermsAgreementFactoryImpl(
                onBoardingQuestionFactory: DIContainer.resolve(
                    type: OnBoardingQuestionFactory.self
                ),
                signUpWithKakaoUseCase: DIContainer.resolve(
                    type: SignUpWithKakaoUseCase.self
                ),
                signUpWithAppleUseCase: DIContainer.resolve(
                    type: SignUpWithAppleUseCase.self
                ),
                fetchTokenUseCase: DIContainer.resolve(
                    type: FetchTokenFromLocalUseCase.self
                ),
                updateMarketingAgreementUseCase: DIContainer.resolve(
                    type: UpdateMarketingAgreementUseCase.self
                )
            )
        }
        DIContainer.register(type: OnBoardingNotificationFactory.self) {
            OnBoardingNotificationFactoryImpl(
                onBoardingNotificationSheetFactory: DIContainer.resolve(
                    type: OnBoardingNotificationSheetFactory.self
                ),
                appCoordinator: {
                    DIContainer.resolve(
                        type: AppCoordinatorProtocol.self
                    )
                }
            )
        }
        DIContainer.register(type: BookmarkMainFactory.self) {
            BookmarkMainFactoryImpl(
                setBookmarkUseCase:
                DIContainer
                    .resolve(type: SetBookmarkUseCase.self),
                checkLoginUseCase:
                DIContainer
                    .resolve(type: CheckLoginUseCase.self),
                fetchVisitBookmarkUseCase:
                DIContainer
                    .resolve(type: FetchVisitBookmarkUseCase.self),
                onBoardingFactory:
                DIContainer
                    .resolve(type: BookmarkOnBoardingFactory.self),
                bookmarkListFactory:
                DIContainer
                    .resolve(type: BookmarkListFactory.self),
                collectionListFactory:
                DIContainer
                    .resolve(type: CollectionListFactory.self),
                searchFactory:
                DIContainer
                    .resolve(type: DictionarySearchFactory.self),
                notificationFactory: DIContainer.resolve(
                    type: DictionaryNotificationFactory.self
                ),
                loginFactory: DIContainer.resolve(type: LoginFactory.self)
            )
        }
        DIContainer.register(type: BookmarkOnBoardingFactory.self) {
            BookmarkOnBoardingFactoryImpl()
        }
        DIContainer.register(type: BookmarkListFactory.self) {
            BookmarkListFactoryImpl(
                itemFilterFactory: DIContainer.resolve(
                    type: ItemFilterBottomSheetFactory.self
                ),
                monsterFilterFactory: DIContainer.resolve(
                    type: MonsterFilterBottomSheetFactory.self
                ),
                sortedFactory: DIContainer.resolve(
                    type: SortedBottomSheetFactory.self
                ),
                bookmarkModalFactory: DIContainer.resolve(
                    type: BookmarkModalFactory.self
                ),
                loginFactory: DIContainer.resolve(type: LoginFactory.self),
                dictionaryDetailFactory: DIContainer.resolve(
                    type: DictionaryDetailFactory.self
                ),
                collectionEditFactory: DIContainer.resolve(
                    type: CollectionEditFactory.self
                ),
                setBookmarkUseCase: DIContainer.resolve(
                    type: SetBookmarkUseCase.self
                ),
                fetchProfileUseCase: DIContainer.resolve(
                    type: FetchProfileUseCase.self
                ),
                fetchBookmarkUseCase: DIContainer.resolve(
                    type: FetchBookmarkUseCase.self
                ),
                fetchMonsterBookmarkUseCase: DIContainer.resolve(
                    type: FetchMonsterBookmarkUseCase.self
                ),
                fetchItemBookmarkUseCase: DIContainer.resolve(
                    type: FetchItemBookmarkUseCase.self
                ),
                fetchNPCBookmarkUseCase: DIContainer.resolve(
                    type: FetchNPCBookmarkUseCase.self
                ),
                fetchQuestBookmarkUseCase: DIContainer.resolve(
                    type: FetchQuestBookmarkUseCase.self
                ),
                fetchMapBookmarkUseCase: DIContainer.resolve(
                    type: FetchMapBookmarkUseCase.self
                ),
                parseItemFilterResultUseCase: DIContainer.resolve(
                    type: ParseItemFilterResultUseCase.self
                )
            )
        }
        DIContainer.register(type: CollectionListFactory.self) {
            CollectionListFactoryImpl(
                fetchCollectionListUseCase: DIContainer.resolve(
                    type: FetchCollectionListUseCase.self
                ),
                addCollectionFactory: DIContainer.resolve(
                    type: AddCollectionFactory.self
                ),
                bookmarkDetailFactory: DIContainer.resolve(
                    type: CollectionDetailFactory.self
                ),
                sortedBottomSheetFactory:
                DIContainer
                    .resolve(type: SortedBottomSheetFactory.self)
            )
        }
        DIContainer.register(type: CollectionDetailFactory.self) {
            CollectionDetailFactoryImpl(
                bookmarkModalFactory:
                DIContainer
                    .resolve(type: BookmarkModalFactory.self),
                collectionSettingFactory:
                DIContainer
                    .resolve(type: CollectionSettingFactory.self),
                addCollectionFactory:
                DIContainer
                    .resolve(type: AddCollectionFactory.self),
                collectionEditFactory:
                DIContainer
                    .resolve(type: CollectionEditFactory.self),
                dictionaryDetailFactory:
                DIContainer
                    .resolve(type: DictionaryDetailFactory.self),
                setBookmarkUseCase:
                DIContainer
                    .resolve(type: SetBookmarkUseCase.self),
                fetchCollectionUseCase: DIContainer.resolve(
                    type: FetchCollectionUseCase.self
                ),
                deleteCollectionUseCase:
                DIContainer
                    .resolve(type: DeleteCollectionUseCase.self),
                addCollectionAndBookmarkUseCase: DIContainer.resolve(
                    type: AddCollectionAndBookmarkUseCase.self
                )
            )
        }
        DIContainer.register(type: CollectionSettingFactory.self) {
            CollectionSettingFactoryImpl()
        }
        DIContainer.register(type: CollectionEditFactory.self) {
            CollectionEditFactoryImpl(
                setBookmarkUseCase: DIContainer.resolve(
                    type: SetBookmarkUseCase.self
                ),
                bookmarkModalFactory: DIContainer.resolve(
                    type: BookmarkModalFactory.self
                )
            )
        }
        DIContainer.register(type: MyPageMainFactory.self) {
            MyPageMainFactoryImpl(
                loginFactory: DIContainer.resolve(type: LoginFactory.self),
                setProfileFactory:
                DIContainer
                    .resolve(type: SetProfileFactory.self),
                customerSupportFactory:
                DIContainer
                    .resolve(type: CustomerSupportFactory.self),
                notificationSettingFactory:
                DIContainer
                    .resolve(type: NotificationSettingFactory.self),
                setCharacterFactory:
                DIContainer
                    .resolve(type: SetCharacterFactory.self),
                fetchProfileUseCase: DIContainer.resolve(
                    type: FetchProfileUseCase.self
                )
            )
        }
        DIContainer.register(type: CustomerSupportFactory.self) {
            CustomerSupportBaseViewFactoryImpl(
                policyFactory: DIContainer.resolve(
                    type: PolicyFactory.self),
                fetchNoticesUseCase: DIContainer.resolve(
                    type: FetchNoticesUseCase.self
                ),
                fetchOngoingEventsUseCase: DIContainer.resolve(
                    type: FetchOngoingEventsUseCase.self
                ),
                fetchOutdatedEventsUseCase: DIContainer.resolve(
                    type: FetchOutdatedEventsUseCase.self
                ),
                fetchPatchNotesUseCase: DIContainer.resolve(
                    type: FetchPatchNotesUseCase.self
                ),
                setReadUseCase: DIContainer.resolve(type: SetReadUseCase.self)
            )
        }
        DIContainer.register(type: SetProfileFactory.self) {
            SetProfileFactoryImpl(
                selectImageFactory: DIContainer.resolve(
                    type: SelectImageFactory.self
                ),
                checkNickNameUseCase: DIContainer.resolve(
                    type: CheckNickNameUseCase.self
                ),
                updateNickNameUseCase: DIContainer.resolve(
                    type: UpdateNickNameUseCase.self
                ),
                logoutUseCase: DIContainer.resolve(type: LogoutUseCase.self),
                withdrawUseCase: DIContainer.resolve(
                    type: WithdrawUseCase.self
                ),
                fetchProfileUseCase: DIContainer.resolve(
                    type: FetchProfileUseCase.self
                )
            )
        }
        DIContainer.register(type: SetCharacterFactory.self) {
            SetCharacterFactoryImpl(
                checkEmptyUseCase:
                DIContainer
                    .resolve(type: CheckEmptyLevelAndRoleUseCase.self),
                checkValidLevelUseCase:
                DIContainer
                    .resolve(type: CheckValidLevelUseCase.self),
                fetchJobListUseCase:
                DIContainer
                    .resolve(type: FetchJobListUseCase.self),
                updateUserInfoUseCase:
                DIContainer
                    .resolve(type: UpdateUserInfoUseCase.self)
            )
        }
        DIContainer.register(type: SelectImageFactory.self) {
            SelectImageFactoryImpl(
                updateProfileImageUseCase: DIContainer.resolve(
                    type: UpdateProfileImageUseCase.self
                )
            )
        }
        DIContainer.register(type: DetailOnBoardingFactory.self) {
            DetailOnBoardingFactoryImpl()
        }
        DIContainer.register(type: PolicyFactory.self) {
            PolicyFactoryImpl()
        }
    }
}
