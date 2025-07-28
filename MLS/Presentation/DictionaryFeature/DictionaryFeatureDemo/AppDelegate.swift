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
            return NetworkProviderImpl()
        }
        DIContainer.register(type: SocialAuthenticatableProvider.self, name: "kakao") {
            return KakaoLoginProviderMock()
        }
        DIContainer.register(type: SocialAuthenticatableProvider.self, name: "apple") {
            return AppleLoginProviderMock()
        }
    }

    func registerRepository() {
        DIContainer.register(type: UserDefaultsRespository.self) {
            return BookmarkOnBoardingRepositoryImpl()
        }
        DIContainer.register(type: AuthAPIRepository.self) {
            return AuthAPIRepositoryMock(provider: DIContainer.resolve(type: NetworkProvider.self))
        }
        DIContainer.register(type: TokenRepository.self) {
            return KeyChainRepositoryImpl()
        }
        DIContainer.register(type: DictionaryListRepository.self) {
            return DictionaryListRepositoryImpl(allItems: [
                DictionaryItem(id: "1", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "2", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
//                DictionaryItem(id: "3", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "4", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "5", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "6", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
//                DictionaryItem(id: "7", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "8", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "51", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "52", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
//                DictionaryItem(id: "53", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "54", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "55", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "56", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
//                DictionaryItem(id: "57", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "58", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "31", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "32", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
//                DictionaryItem(id: "33", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "34", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "35", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "36", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
//                DictionaryItem(id: "37", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "38", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "41", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "42", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
//                DictionaryItem(id: "43", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "44", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "45", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "46", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
//                DictionaryItem(id: "47", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "48", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "11", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "12", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
//                DictionaryItem(id: "13", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "14", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "15", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "16", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
//                DictionaryItem(id: "17", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "18", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "61", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "62", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
//                DictionaryItem(id: "63", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "64", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "65", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "66", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
//                DictionaryItem(id: "67", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
//                DictionaryItem(id: "68", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false)
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
            return CheckEmptyLevelAndRoleUseCaseImpl()
        }
        DIContainer.register(type: CheckValidLevelUseCase.self) {
            return CheckValidLevelUseCaseImpl()
        }
        DIContainer.register(type: FetchJobListUseCase.self) {
            return FetchJobListUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: LoginWithAppleUseCase.self) {
            return LoginWithAppleUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: LoginWithKakaoUseCase.self) {
            return LoginWithKakaoUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: SignUpWithAppleUseCase.self) {
            return SignUpWithAppleUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: SignUpWithKakaoUseCase.self) {
            return SignUpWithKakaoUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: UpdateUserInfoUseCase.self) {
            return UpdateUserInfoUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: FetchTokenFromLocalUseCase.self) {
            return FetchTokenFromLocalUseCaseImpl(repository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: SaveTokenToLocalUseCase.self) {
            return SaveTokenToLocalUseCaseImpl(repository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: DeleteTokenFromLocalUseCase.self) {
            return DeleteTokenFromLocalUseCaseImpl(repository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: FetchDictionaryItemsUseCase.self) {
            return FetchDictionaryItemsUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListRepository.self))
        }
        DIContainer.register(type: ToggleBookmarkUseCase.self) {
            return ToggleBookmarkUseCaseImpl(repository: DIContainer.resolve(type: DictionaryListRepository.self))
        }
        DIContainer.register(type: FetchNotificationUseCase.self) {
            return FetchNotificationUseCaseImpl()
        }
        DIContainer.register(type: GetBookmarkOnboardingUseCase.self) {
            return GetBookmarkOnboardingUseCaseImpl(repository: DIContainer.resolve(type: UserDefaultsRespository.self))
        }
        DIContainer.register(type: SetBookmarkOnBoardingUseCase.self) {
            return SetBookmarkOnBoardingUseCaseImpl(repository: DIContainer.resolve(type: UserDefaultsRespository.self))
        }
        DIContainer.register(type: CheckLoginUseCase.self) {
            return CheckLoginUseCaseImpl(authRepository: DIContainer.resolve(type: AuthAPIRepository.self), tokenRepository: DIContainer.resolve(type: TokenRepository.self))
        }
    }

    func registerFactory() {
        DIContainer.register(type: ItemFilterBottomSheetFactory.self) {
            return ItemFilterBottomSheetFactoryImpl()
        }
        DIContainer.register(type: MonsterFilterBottomSheetFactory.self) {
            return MonsterFilterBottomSheetFactoryImpl()
        }
        DIContainer.register(type: SortedBottomSheetFactory.self) {
            return SortedBottomSheetFactoryImpl()
        }
        DIContainer.register(type: BookmarkModalFactory.self) {
            return BookmarkModalFactoryImpl(addCollectionFactory: DIContainer.resolve(type: AddCollectionFactory.self))
        }
        DIContainer.register(type: DictionaryMainListFactory.self) {
            return DictionaryListFactoryImpl(
                fetchDictionaryItemsUseCase: DIContainer.resolve(type: FetchDictionaryItemsUseCase.self),
                toggleBookmarkUseCase: DIContainer.resolve(type: ToggleBookmarkUseCase.self),
                itemFilterFactory: DIContainer.resolve(type: ItemFilterBottomSheetFactory.self),
                monsterFilterFactory: DIContainer.resolve(type: MonsterFilterBottomSheetFactory.self),
                sortedFactory: DIContainer.resolve(type: SortedBottomSheetFactory.self),
                bookmarkModalFactory: DIContainer.resolve(type: BookmarkModalFactory.self)
            )
        }
        DIContainer.register(type: DictionarySearchResultFactory.self) {
            return DictionarySearchResultFactoryImpl(
                dictionaryMainListFactory: DIContainer
                    .resolve(type: DictionaryMainListFactory.self)
            )
        }
        DIContainer.register(type: DictionarySearchFactory.self) {
            return DictionarySearchFactoryImpl(
                searchResultFactory: DIContainer
                    .resolve(type: DictionarySearchResultFactory.self)
            )
        }
        DIContainer.register(type: NotificationSettingFactory.self) {
            return NotificationSettingFactoryImpl()
        }
        DIContainer.register(type: DictionaryNotificationFactory.self) {
            return DictionaryNotificationFactoryImpl(
                fetchNotificationUseCase: DIContainer
                    .resolve(type: FetchNotificationUseCase.self),
                notificationSettingFactory: DIContainer
                    .resolve(type: NotificationSettingFactory.self)
            )
        }
        DIContainer.register(type: DictionaryMainViewFactory.self) {
            return DictionaryMainViewFactoryImpl(
                dictionaryMainListFactory: DIContainer
                    .resolve(type: DictionaryMainListFactory.self),
                searchFactory: DIContainer.resolve(type: DictionarySearchFactory.self),
                notificationFactory: DIContainer
                    .resolve(type: DictionaryNotificationFactory.self)
            )
        }
        DIContainer.register(type: BookmarkOnBoardingFactory.self) {
            return BookmarkOnBoardingFactoryImpl()
        }
        DIContainer.register(type: OnBoardingInputFactory.self) {
            return OnBoardingInputFactoryImpl(checkEmptyUseCase: DIContainer.resolve(type: CheckEmptyLevelAndRoleUseCase.self), checkValidLevelUseCase: DIContainer.resolve(type: CheckValidLevelUseCase.self), fetchJobListUseCase: DIContainer.resolve(type: FetchJobListUseCase.self), updateUserInfoUseCase: DIContainer.resolve(type: UpdateUserInfoUseCase.self))
        }
        DIContainer.register(type: OnBoardingQuestionFactory.self) {
            return OnBoardingQuestionFactoryImpl(onBoardingInputFactory: DIContainer.resolve(type: OnBoardingInputFactory.self))
        }
        DIContainer.register(type: TermsAgreementFactory.self) {
            return TermsAgreementFactoryImpl(onBoardingQuestionFactory: DIContainer.resolve(type: OnBoardingQuestionFactory.self), signUpWithKakaoUseCase: DIContainer.resolve(type: SignUpWithKakaoUseCase.self), signUpWithAppleUseCase: DIContainer.resolve(type: SignUpWithAppleUseCase.self), saveTokenUseCase: DIContainer.resolve(type: SaveTokenToLocalUseCase.self))
        }
        DIContainer.register(type: LoginFactory.self) {
            return LoginFactoryImpl(
                termsAgreementsFactory: DIContainer
                    .resolve(type: TermsAgreementFactory.self),
                appleLoginUseCase: DIContainer
                    .resolve(type: FetchSocialCredentialUseCase.self, name: "apple"),
                kakaoLoginUseCase: DIContainer
                    .resolve(type: FetchSocialCredentialUseCase.self, name: "kakao"),
                loginWithAppleUseCase: DIContainer
                    .resolve(type: LoginWithAppleUseCase.self),
                loginWithKakaoUseCase: DIContainer
                    .resolve(type: LoginWithKakaoUseCase.self)
            )
        }
        DIContainer.register(type: AddCollectionFactory.self) {
            return AddCollectionFactoryImpl()
        }
        DIContainer.register(type: BookmarkListFactory.self) {
            return BookmarkListFactoryImpl(
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
            return CollectionSettingFactoryImpl()
        }
        DIContainer.register(type: CollectionEditFactory.self) {
            return CollectionEditFactoryImpl(toggleBookmarkUseCase: DIContainer.resolve(type: ToggleBookmarkUseCase.self), bookmarkModalFactory: DIContainer.resolve(type: BookmarkModalFactory.self))
        }
        DIContainer.register(type: CollectionDetailFactory.self) {
            return CollectionDetailFactoryImpl(toggleBookmarkUseCase: DIContainer.resolve(type: ToggleBookmarkUseCase.self), bookmarkModalFactory: DIContainer.resolve(type: BookmarkModalFactory.self), collectionSettingFactory: DIContainer.resolve(type: CollectionSettingFactory.self), addCollectionFactory: DIContainer.resolve(type: AddCollectionFactory.self), collectionEditFactory: DIContainer.resolve(type: CollectionEditFactory.self))
        }
        DIContainer.register(type: CollectionListFactory.self) {
            return CollectionListFactoryImpl(addCollectionFactory: DIContainer.resolve(type: AddCollectionFactory.self), bookmarkDetailFactory: DIContainer.resolve(type: CollectionDetailFactory.self))
        }
        DIContainer.register(type: BookmarkMainFactory.self) {
            return BookmarkMainFactoryImpl(
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
