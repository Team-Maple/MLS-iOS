import UIKit

import MLSCore
import MLSRecommendationFeature
import MLSRecommendationFeatureInterface
import MLSRecommendationFeatureTesting

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        registerDependencies()

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let factory = DIContainer.resolve(type: RecommendationMainFactory.self)
        let recommendationVC = factory.make()
        let nav = UINavigationController(rootViewController: recommendationVC)
        nav.navigationBar.isHidden = true
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    // MARK: - Private

    private func registerDependencies() {
        DIContainer.register(type: RecommendationMainFactory.self) {
            RecommendationMainFactoryImpl(
                repository: MockRecommendationRepository(),
                makeLoginVC: {
                    let vc = UIViewController()
                    vc.view.backgroundColor = .white
                    return vc
                },
                makeCharacterSettingVC: {
                    let vc = UIViewController()
                    vc.view.backgroundColor = .white
                    return vc
                }
            )
        }
    }
}
