import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct LoginFactoryImpl: LoginFactory {
    private let termsAgreementsFactory: TermsAgreementFactory
    private let appleLoginUseCase: FetchSocialCredentialUseCase
    private let kakaoLoginUseCase: FetchSocialCredentialUseCase
    private let loginWithAppleUseCase: LoginWithAppleUseCase
    private let loginWithKakaoUseCase: LoginWithKakaoUseCase
    private let fetchTokenUseCase: FetchTokenFromLocalUseCase
    private let putFCMTokenUseCase: PutFCMTokenUseCase

    public init(
        termsAgreementsFactory: TermsAgreementFactory,
        appleLoginUseCase: FetchSocialCredentialUseCase,
        kakaoLoginUseCase: FetchSocialCredentialUseCase,
        loginWithAppleUseCase: LoginWithAppleUseCase,
        loginWithKakaoUseCase: LoginWithKakaoUseCase,
        fetchTokenUseCase: FetchTokenFromLocalUseCase,
        putFCMTokenUseCase: PutFCMTokenUseCase
    ) {
        self.termsAgreementsFactory = termsAgreementsFactory
        self.appleLoginUseCase = appleLoginUseCase
        self.kakaoLoginUseCase = kakaoLoginUseCase
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.loginWithKakaoUseCase = loginWithKakaoUseCase
        self.fetchTokenUseCase = fetchTokenUseCase
        self.putFCMTokenUseCase = putFCMTokenUseCase
    }

    public func make(
        isReLogin: Bool
    ) -> BaseViewController {
        let viewController = LoginViewController(isRelogin: isReLogin, termsAgreementsFactory: termsAgreementsFactory)
        viewController.reactor = LoginReactor(
            fetchAppleCredentialUseCase: appleLoginUseCase,
            fetchKakaoCredentialUseCase: kakaoLoginUseCase,
            loginWithAppleUseCase: loginWithAppleUseCase,
            loginWithKakaoUseCase: loginWithKakaoUseCase,
            fetchTokenUseCase: fetchTokenUseCase,
            putFCMTokenUseCase: putFCMTokenUseCase
        )
        return viewController
    }
}
