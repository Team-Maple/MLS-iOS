import UIKit

import BaseFeature
import Core
import Data
import DataMock
import DesignSystem
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
    }

    func registerRepository() {
        DIContainer.register(type: AuthAPIRepository.self) {
            return AuthAPIRepositoryMock(provider: DIContainer.resolve(type: NetworkProvider.self))
        }
    }

    func registerUseCase() {
        DIContainer.register(type: CheckNickNameUseCase.self) {
            CheckNickNameUseCaseImpl()
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
        DIContainer.register(type: UpdateUserInfoUseCase.self) {
            UpdateUserInfoUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
    }

    func registerFactory() {
        DIContainer.register(type: SelectImageFactory.self) {
            SelectImageFactoryImpl()
        }

        DIContainer.register(type: SetProfileFactory.self) {
            SetProfileFactoryImpl(selectImageFactory: DIContainer.resolve(type: SelectImageFactory.self), checkNickNameUseCase: DIContainer.resolve(type: CheckNickNameUseCase.self))
        }

        DIContainer.register(type: SetCharacterFactory.self) {
            SetCharacterFactoryImpl(
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

        DIContainer.register(type: MyPageMainFactory.self) {
            MyPageMainFactoryImpl(
                setProfileFactory: DIContainer
                    .resolve(type: SetProfileFactory.self),
                customerSupportFactory: DIContainer
                    .resolve(type: CustomerSupportFactory.self),
                notificationSettingFactory: DIContainer
                    .resolve(type: NotificationSettingFactory.self),
                setCharacterFactory: DIContainer
                    .resolve(type: SetCharacterFactory.self)
            )
        }

        DIContainer.register(type: CustomerSupportFactory.self) {
            CustomerSupportBaseViewFactoryImpl()
        }

        DIContainer.register(type: NotificationSettingFactory.self) {
            NotificationSettingFactoryImpl()
        }
    }
}
