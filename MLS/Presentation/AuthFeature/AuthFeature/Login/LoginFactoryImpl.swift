import AuthFeatureInterface
import BaseFeature
import DomainInterface

import RxSwift

public struct LoginFactoryImpl: LoginFactory {
    private let termsAgreementsFactory: TermsAgreementFactory
    private let appleLoginUseCase: FetchSocialCredentialUseCase
    private let kakaoLoginUseCase: FetchSocialCredentialUseCase
    private let loginWithAppleUseCase: LoginWithAppleUseCase
    private let loginWithKakaoUseCase: LoginWithKakaoUseCase
    private let fetchTokenUseCase: FetchTokenFromLocalUseCase
    private let putFCMTokenUseCase: PutFCMTokenUseCase
    private let fetchPlatformUseCase: FetchPlatformUseCase

    public init(
        termsAgreementsFactory: TermsAgreementFactory,
        appleLoginUseCase: FetchSocialCredentialUseCase,
        kakaoLoginUseCase: FetchSocialCredentialUseCase,
        loginWithAppleUseCase: LoginWithAppleUseCase,
        loginWithKakaoUseCase: LoginWithKakaoUseCase,
        fetchTokenUseCase: FetchTokenFromLocalUseCase,
        putFCMTokenUseCase: PutFCMTokenUseCase,
        fetchPlatformUseCase: FetchPlatformUseCase
    ) {
        self.termsAgreementsFactory = termsAgreementsFactory
        self.appleLoginUseCase = appleLoginUseCase
        self.kakaoLoginUseCase = kakaoLoginUseCase
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.loginWithKakaoUseCase = loginWithKakaoUseCase
        self.fetchTokenUseCase = fetchTokenUseCase
        self.putFCMTokenUseCase = putFCMTokenUseCase
        self.fetchPlatformUseCase = fetchPlatformUseCase
    }

    public func make(exitRoute: LoginExitRoute, onLoginCompleted: (() -> Void)?) -> BaseViewController {
        let viewController = LoginViewController(termsAgreementsFactory: termsAgreementsFactory)
        viewController.isBottomTabbarHidden = true

        viewController.reactor = LoginReactor(
            fetchAppleCredentialUseCase: appleLoginUseCase,
            fetchKakaoCredentialUseCase: kakaoLoginUseCase,
            loginWithAppleUseCase: loginWithAppleUseCase,
            loginWithKakaoUseCase: loginWithKakaoUseCase,
            fetchTokenUseCase: fetchTokenUseCase,
            putFCMTokenUseCase: putFCMTokenUseCase,
            fetchPlatformUseCase: fetchPlatformUseCase
        )

        viewController.routeToHome
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak viewController] in
                switch exitRoute {
                case .home:
                    onLoginCompleted?()
                case .pop:
                    viewController?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: viewController.disposeBag)

        return viewController
    }
}
