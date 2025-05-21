import UIKit

import AuthFeature
import AuthFeatureInterface
import BaseFeature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let loginFactory: LoginFactory = LoginFactoryImpl()
        let termsAgreementsFactory: TermsAgreementFactory = TermsAgreementFactoryImpl()
        let startVC = loginFactory.make(isReLogin: false, termsAgreementsFactory: termsAgreementsFactory)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
