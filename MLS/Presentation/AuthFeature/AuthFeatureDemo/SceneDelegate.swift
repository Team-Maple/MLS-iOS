import UIKit

import AuthFeature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        let startVC = TermsAgreementViewController()
//        startVC.reactor = TermsAgreementReactor()
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: windowScene)
//        window?.rootViewController = UINavigationController(rootViewController: startVC)
//        window?.makeKeyAndVisible()

//        let startVC = onBoardingQuestionViewController()
        let startVC = OnBoardingInputViewController()
        let navController = CustomNavigationController(rootViewController: startVC)
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
