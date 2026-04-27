import UIKit

import MLSAuthFeatureTesting
import MLSMyPageFeature
import MLSMyPageFeatureInterface
import MLSMyPageFeatureTesting

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let rootVC = makeMyPageViewController()
        let nav = UINavigationController(rootViewController: rootVC)
        nav.navigationBar.isHidden = true
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    func makeMyPageViewController() -> UIViewController {
        let myPageRepository = MockMyPageRepository()
        let authRepository = MockAuthAPIRepository()
        let tokenRepository = MockTokenRepository()
        let alarmRepository = MockAlarmRepository()

        let fetchProfileUseCase = FetchProfileUseCaseImpl(repository: myPageRepository)

        let setProfileFactory = SetProfileFactoryImpl(
            selectImageFactory: SelectImageFactoryImpl(myPageRepository: myPageRepository),
            checkNickNameUseCase: CheckNickNameUseCaseImpl(),
            logoutUseCase: LogoutUseCaseImpl(repository: tokenRepository),
            withdrawUseCase: WithdrawUseCaseImpl(authRepository: authRepository, tokenRepository: tokenRepository),
            fetchProfileUseCase: fetchProfileUseCase,
            myPageRepository: myPageRepository
        )

        let customerSupportFactory = CustomerSupportBaseViewFactoryImpl(
            policyFactory: PolicyFactoryImpl(),
            alarmRepository: alarmRepository
        )

        let notificationSettingFactory = NotificationSettingFactoryImpl(
            checkNotificationPermissionUseCase: CheckNotificationPermissionUseCaseImpl(),
            authRepository: authRepository
        )

        let setCharacterFactory = SetCharacterFactoryImpl(
            checkEmptyUseCase: CheckEmptyLevelAndRoleUseCaseImpl(),
            checkValidLevelUseCase: CheckValidLevelUseCaseImpl(),
            authRepository: authRepository
        )

        let loginFactory = MockLoginFactory()

        let myPageFactory = MyPageMainFactoryImpl(
            loginFactory: loginFactory,
            setProfileFactory: setProfileFactory,
            customerSupportFactory: customerSupportFactory,
            notificationSettingFactory: notificationSettingFactory,
            setCharacterFactory: setCharacterFactory,
            fetchProfileUseCase: fetchProfileUseCase
        )

        return myPageFactory.make()
    }
}
