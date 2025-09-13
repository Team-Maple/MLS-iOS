import UIKit

import BaseFeature
import Core
import DesignSystem
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

    func registerProvider() {}

    func registerRepository() {}

    func registerUseCase() {}

    func registerFactory() {
        DIContainer.register(type: SetProfileFactory.self) {
            SetProfileFactoryImpl()
        }
        
        DIContainer.register(type: MyPageMainFactory.self) {
            MyPageMainFactoryImpl(setProfileFactory: DIContainer.resolve(type: SetProfileFactory.self))
        }
    }
}
