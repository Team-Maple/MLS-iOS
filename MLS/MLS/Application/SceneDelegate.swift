import UIKit

import AuthFeature
import AuthFeatureInterface
import Core
import Data
import Domain
import DomainInterface

import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let loginFactory: LoginFactory = DIContainer.resolve(type: LoginFactory.self)
        window = UIWindow(windowScene: windowScene)
        let startViewController = loginFactory.make(
            isReLogin: false,
            termsAgreementsFactory: DIContainer.resolve(type: TermsAgreementFactory.self),
            appleLoginUseCase: DIContainer.resolve(type: SocialLoginUseCase.self, name: "apple"),
            kakaoLoginUseCase: DIContainer.resolve(type: SocialLoginUseCase.self, name: "kakao")
        )
        window?.rootViewController = startViewController
        window?.makeKeyAndVisible()
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
}
