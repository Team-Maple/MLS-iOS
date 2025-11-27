import UIKit

import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import Core
import DictionaryFeatureInterface
import DomainInterface
import MyPageFeatureInterface

import KakaoSDKAuth
import RxSwift

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinatorProtocol?
    var disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        self.window = window

        let coordinator = DIContainer.resolve(type: AppCoordinatorProtocol.self)
        coordinator.window = window
        self.appCoordinator = coordinator

        startScene(coordinator: coordinator)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
            if let url = URLContexts.first?.url {
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }

    private func startScene(coordinator: AppCoordinatorProtocol) {
        let fetchTokenUseCase = DIContainer.resolve(type: FetchTokenFromLocalUseCase.self)
        let reissueUseCase = DIContainer.resolve(type: ReissueUseCase.self)
        let saveTokenUseCase = DIContainer.resolve(type: SaveTokenToLocalUseCase.self)

        let fetchResult = fetchTokenUseCase.execute(type: .refreshToken)

        switch fetchResult {
        case .success(let refreshToken):
            // ✅ refreshToken 존재 → accessToken 재발급 시도
            reissueUseCase.execute(refreshToken: refreshToken)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onNext: { response in
                        let accessSave = saveTokenUseCase.execute(type: .accessToken, value: response.accessToken)
                        let refreshSave = saveTokenUseCase.execute(type: .refreshToken, value: response.refreshToken)

                        if case .success = accessSave, case .success = refreshSave {
                            coordinator.showMainTab()
                        } else {
                            coordinator.showLogin(exitRoute: .home)
                        }
                    },
                    onError: { _ in
                        coordinator.showLogin(exitRoute: .home)
                    }
                )
                .disposed(by: disposeBag)

        case .failure:
            // ✅ refreshToken 없으면 바로 로그인으로
            coordinator.showLogin(exitRoute: .home)
        }
    }
}
