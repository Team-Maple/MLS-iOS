import NotificationCenter
import UIKit

import AuthFeature
import AuthFeatureInterface
import BaseFeature
import Core
import Data
import Domain
import DomainInterface

import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        setStartViewController(window: window)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func setStartViewController(window: UIWindow?) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let loginFactory: LoginFactory = DIContainer.resolve(type: LoginFactory.self)
                let notificationFactory: NotificationFactory = DIContainer.resolve(type: NotificationFactory.self)
                if settings.authorizationStatus == .notDetermined {
                    window?.rootViewController = UINavigationController(rootViewController: notificationFactory.make())
                } else {
                    window?.rootViewController = UINavigationController(rootViewController: loginFactory.make(isReLogin: false))
                }
                window?.makeKeyAndVisible()
            }
        }
    }
}
