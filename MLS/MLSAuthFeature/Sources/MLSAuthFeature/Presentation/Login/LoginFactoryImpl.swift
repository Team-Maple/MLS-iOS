import MLSAppFeatureInterface
import MLSAuthFeatureInterface
import MLSCore

import RxSwift

public struct LoginFactoryImpl: LoginFactory {
    private let termsAgreementsFactory: TermsAgreementFactory
    private let appleProvider: SocialCredentialProvider
    private let kakaoProvider: SocialCredentialProvider
    private let socialLoginUseCase: SocialLoginUseCase
    private let userDefaultsRepository: UserDefaultsRepository

    public init(
        termsAgreementsFactory: TermsAgreementFactory,
        appleProvider: SocialCredentialProvider,
        kakaoProvider: SocialCredentialProvider,
        socialLoginUseCase: SocialLoginUseCase,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.termsAgreementsFactory = termsAgreementsFactory
        self.appleProvider = appleProvider
        self.kakaoProvider = kakaoProvider
        self.socialLoginUseCase = socialLoginUseCase
        self.userDefaultsRepository = userDefaultsRepository
    }

    public func make(exitRoute: LoginExitRoute, onLoginCompleted: (() -> Void)?) -> BaseViewController {
        let viewController = LoginViewController(termsAgreementsFactory: termsAgreementsFactory)
        viewController.isBottomTabbarHidden = true

        viewController.reactor = LoginReactor(
            appleProvider: appleProvider,
            kakaoProvider: kakaoProvider,
            socialLoginUseCase: socialLoginUseCase,
            userDefaultsRepository: userDefaultsRepository
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
