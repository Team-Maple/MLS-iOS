import UIKit
import MLSAuthFeature
import MLSAuthFeatureInterface

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AppCoordinatorProtocol {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let loginVC = makeLoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        nav.navigationBar.isHidden = true
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    // MARK: - AppCoordinatorProtocol

    func showMainTab() {
        let alert = UIAlertController(title: "로그인 성공 🎉", message: "메인 화면으로 이동합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        window?.rootViewController?.present(alert, animated: true)
    }

    func showLogin(exitRoute: LoginExitRoute) {
        guard let nav = window?.rootViewController as? UINavigationController else { return }
        let loginVC = makeLoginViewController()
        nav.setViewControllers([loginVC], animated: true)
    }

    // MARK: - Private

    private func makeLoginViewController() -> UIViewController {
        let tokenRepository = MockTokenRepository()
        let userDefaultsRepository = MockUserDefaultsRepository()
        let authRepository = MockAuthAPIRepository()

        let appleProvider = AppleLoginProviderImpl()
        let kakaoProvider = KakaoLoginProviderImpl()

        let factory = LoginFactoryImpl(
            termsAgreementsFactory: makeTermsAgreementFactory(
                authRepository: authRepository,
                tokenRepository: tokenRepository,
                userDefaultsRepository: userDefaultsRepository
            ),
            appleLoginUseCase: SocialLoginUseCaseImpl(provider: appleProvider),
            kakaoLoginUseCase: SocialLoginUseCaseImpl(provider: kakaoProvider),
            loginWithAppleUseCase: LoginWithAppleUseCaseImpl(
                authRepository: authRepository,
                tokenRepository: tokenRepository,
                userDefaultsRepository: userDefaultsRepository
            ),
            loginWithKakaoUseCase: LoginWithKakaoUseCaseImpl(
                authRepository: authRepository,
                tokenRepository: tokenRepository,
                userDefaultsRepository: userDefaultsRepository
            ),
            fetchTokenUseCase: FetchTokenFromLocalUseCaseImpl(repository: tokenRepository),
            putFCMTokenUseCase: PutFCMTokenUseCaseImpl(repository: authRepository),
            fetchPlatformUseCase: FetchPlatformUseCaseImpl(repository: userDefaultsRepository)
        )

        return factory.make(exitRoute: .home, onLoginCompleted: { [weak self] in
            self?.showMainTab()
        })
    }

    private func makeTermsAgreementFactory(
        authRepository: AuthAPIRepository,
        tokenRepository: TokenRepository,
        userDefaultsRepository: UserDefaultsRepository
    ) -> TermsAgreementFactory {
        let onBoardingInputFactory = OnBoardingInputFactoryImpl(
            checkEmptyUseCase: CheckEmptyLevelAndRoleUseCaseImpl(),
            checkValidLevelUseCase: CheckValidLevelUseCaseImpl(),
            fetchJobListUseCase: FetchJobListUseCaseImpl(repository: authRepository),
            updateUserInfoUseCase: UpdateUserInfoUseCaseImpl(repository: authRepository),
            onBoardingNotificationFactory: makeOnBoardingNotificationFactory(
                authRepository: authRepository,
                tokenRepository: tokenRepository
            ),
            appCoordinator: { [weak self] in self! }
        )

        let onBoardingQuestionFactory = OnBoardingQuestionFactoryImpl(
            onBoardingInputFactory: onBoardingInputFactory
        )

        return TermsAgreementFactoryImpl(
            onBoardingQuestionFactory: onBoardingQuestionFactory,
            signUpWithKakaoUseCase: SignUpWithKakaoUseCaseImpl(
                authRepository: authRepository,
                tokenRepository: tokenRepository,
                userDefaultsRepository: userDefaultsRepository
            ),
            signUpWithAppleUseCase: SignUpWithAppleUseCaseImpl(
                authRepository: authRepository,
                tokenRepository: tokenRepository,
                userDefaultsRepository: userDefaultsRepository
            ),
            fetchTokenUseCase: FetchTokenFromLocalUseCaseImpl(repository: tokenRepository),
            updateMarketingAgreementUseCase: UpdateMarketingAgreementUseCaseImpl(repository: authRepository)
        )
    }

    private func makeOnBoardingNotificationFactory(
        authRepository: AuthAPIRepository,
        tokenRepository: TokenRepository
    ) -> OnBoardingNotificationFactory {
        let sheetFactory = OnBoardingNotificationSheetFactoryImpl(
            checkNotificationPermissionUseCase: CheckNotificationPermissionUseCaseImpl(),
            openNotificationSettingUseCase: OpenNotificationSettingUseCaseImpl(),
            updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCaseImpl(repository: authRepository),
            updateUserInfoUseCase: UpdateUserInfoUseCaseImpl(repository: authRepository),
            appCoordinator: { [weak self] in self! }
        )

        return OnBoardingNotificationFactoryImpl(
            onBoardingNotificationSheetFactory: sheetFactory,
            appCoordinator: { [weak self] in self! }
        )
    }
}
