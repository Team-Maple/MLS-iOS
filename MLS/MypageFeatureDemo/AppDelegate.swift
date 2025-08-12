import UIKit

import MypageFeature
import MypageFeatureInterface
import BaseFeature
import Core
import Data
import DataMock
import DesignSystem
import Domain
import DomainInterface

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FontManager.registerFonts()
        registerDependencies()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

private extension AppDelegate {
    func registerDependencies() {
        registerFactory()
    }
    
    func registerFactory() {
        DIContainer.register(type: MypageFactory.self) {
            return MyPageFactoryImpl()
        }
    }
}

