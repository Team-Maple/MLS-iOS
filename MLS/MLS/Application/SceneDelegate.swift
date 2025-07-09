import NotificationCenter
import UIKit

import AuthFeature
import AuthFeatureInterface
import BaseFeature
import Core
import Data
import DictionaryFeature
import DictionaryFeatureInterface
import Domain
import DomainInterface

import KakaoSDKAuth
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var disposeBag = DisposeBag()

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
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let loginFactory: LoginFactory = DIContainer.resolve(type: LoginFactory.self)
                let notificationFactory: NotificationFactory = DIContainer.resolve(type: NotificationFactory.self)
                window?.makeKeyAndVisible()
                if settings.authorizationStatus == .notDetermined {
                    window?.rootViewController = UINavigationController(rootViewController: notificationFactory.make())
                } else {
                    let reissueUseCase = DIContainer.resolve(type: ReissueUseCase.self)
                    let fetchTokenUseCase = DIContainer.resolve(type: FetchTokenFromLocalUseCase.self)
                    let saveTokenUseCase = DIContainer.resolve(type: SaveTokenToLocalUseCase.self)
                    let fetchResult = fetchTokenUseCase.execute(type: .refreshToken)

                    switch fetchResult {
                    case .success(let token):
                        reissueUseCase.execute(refreshToken: token)
                            .observe(on: MainScheduler.instance)
                            .subscribe { response in
                                let accessSaveResult = saveTokenUseCase.execute(type: .accessToken, value: response.accessToken)
                                let refreshSaveResult = saveTokenUseCase.execute(type: .refreshToken, value: response.refreshToken)
                                window?.rootViewController = UINavigationController(rootViewController: ViewController())
                                if case .success = accessSaveResult, case .success = refreshSaveResult {
                                    // 저장 결과 모두 성공일 때만 진입
                                    window?.rootViewController = UINavigationController(rootViewController: ViewController())
                                } else {
                                    // 저장 실패 시 로그인 화면으로 이동
                                    window?.rootViewController = UINavigationController(rootViewController: loginFactory.make(isReLogin: false))
                                }
                            } onError: { _ in
                                window?.rootViewController = UINavigationController(rootViewController: loginFactory.make(isReLogin: false))
                            }
                            .disposed(by: self.disposeBag)
                    case .failure:
                        window?.rootViewController = UINavigationController(rootViewController: loginFactory.make(isReLogin: false))
                    }
                }
            }
        }
    }
}
