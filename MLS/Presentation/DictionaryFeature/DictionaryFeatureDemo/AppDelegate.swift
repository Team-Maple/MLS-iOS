import UIKit

import BaseFeature
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
        DIContainer.register(type: AuthAPIRepository.self) {
            return AuthAPIRepositoryMock()
        }
        DIContainer.register(type: TokenRepository.self) {
            return KeyChainRepositoryImpl()
        }
        DIContainer.register(type: DictionaryListRepository.self) {
            return DictionaryListRepositoryImpl(allItems: [
                DictionaryItem(id: "1", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "2", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "3", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "4", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "5", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "6", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "7", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "8", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "51", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "52", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "53", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "54", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "55", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "56", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "57", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "58", type: .item, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "31", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "32", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "33", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "34", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "35", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "36", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "37", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "38", type: .monster, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "41", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "42", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "43", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "44", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "45", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "46", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "47", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "48", type: .map, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "11", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "12", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "13", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "14", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "15", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "16", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "17", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "18", type: .quest, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "61", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "62", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "63", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "64", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "65", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "66", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: true),
                DictionaryItem(id: "67", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false),
                DictionaryItem(id: "68", type: .npc, mainText: "최대 줄은 두 줄입니다.\n넘어갈시 말줄임 처리 합니다.", subText: "Lv.표시", image: DesignSystemAsset.image(named: "testImage")!, isBookmarked: false)
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
    }

    func registerFactory() {

        DIContainer.register(type: ItemFilterBottomSheetFactory.self) {
            return ItemFilterBottomSheetFactoryImpl()
        }
        DIContainer.register(type: DictionaryMainListFactory.self) {
            return DictionaryListFactoryImpl(fetchDictionaryItemsUseCase: DIContainer.resolve(type: FetchDictionaryItemsUseCase.self), toggleBookmarkUseCase: DIContainer.resolve(type: ToggleBookmarkUseCase.self))
        }
        DIContainer.register(type: DictionarySearchResultFactory.self) {
            return DictionarySearchResultFactoryImpl(dictionaryMainListFactory: DIContainer.resolve(type: DictionaryMainListFactory.self))
        }
        DIContainer.register(type: DictionarySearchFactory.self) {
            return DictionarySearchFactoryImpl(searchResultFactory: DIContainer.resolve(type: DictionarySearchResultFactory.self))
        }
        DIContainer.register(type: DictionaryMainViewFactory.self) {
            return DictionaryMainViewFactoryImpl(dictionaryMainListFactory: DIContainer.resolve(type: DictionaryMainListFactory.self), searchFactory: DIContainer.resolve(type: DictionarySearchFactory.self))
        }
        DIContainer.register(type: MonsterFilterBottomSheetFactory.self) {
            return MonsterFilterBottomSheetFactoryImpl()
        }
        DIContainer.register(type: SortedBottomSheetFactory.self) {
            return SortedBottomSheetFactoryImpl()
        }
    }
}
