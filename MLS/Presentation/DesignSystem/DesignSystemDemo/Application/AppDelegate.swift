import UIKit

import AuthFeature
import AuthFeatureInterface
import Core
import Data
import DesignSystem
import Domain
import DomainInterface

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FontManager.registerFonts()
        registerDependencies()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

private extension AppDelegate {
    func registerDependencies() {
        registerProvider()
        registerUseCase()
        registerFactory()
    }

    func registerProvider() {
        DIContainer.register(type: NetworkProvider.self) {
            return NetworkProviderImpl()
        }
        DIContainer.register(type: SocialAuthenticatableProvider.self, name: "kakao") {
            return KakaoLoginProviderImpl()
        }
        DIContainer.register(type: SocialAuthenticatableProvider.self, name: "apple") {
            return AppleLoginProviderImpl()
        }
    }

    func registerUseCase() {
        DIContainer.register(type: SocialLoginUseCase.self, name: "kakao") {
            let provider = DIContainer.resolve(type: SocialAuthenticatableProvider.self, name: "kakao")
            return SocialLoginUseCaseImpl(provider: provider)
        }
        DIContainer.register(type: SocialLoginUseCase.self, name: "apple") {
            let provider = DIContainer.resolve(type: SocialAuthenticatableProvider.self, name: "apple")
            return SocialLoginUseCaseImpl(provider: provider)
        }
        DIContainer.register(type: CheckEmptyLevelAndRoleUseCase.self) {
            return CheckEmptyLevelAndRoleUseCaseImpl()
        }
        DIContainer.register(type: CheckValidLevelUseCase.self) {
            return CheckValidLevelUseCaseImpl()
        }
    }

    func registerFactory() {
        DIContainer.register(type: TermsAgreementFactory.self) {
            return TermsAgreementFactoryImpl()
        }
        DIContainer.register(type: OnBoardingFactory.self, name: "onBoardingQuestion") {
            return OnBoardingQuestionFactoryImpl()
        }
        DIContainer.register(type: OnBoardingFactory.self, name: "onBoardingInput") {
            return OnBoardingInputFactoryImpl()
        }
        DIContainer.register(type: OnBoardingFactory.self, name: "onBoardingNotification") {
            return OnBoardingNotificationFactoryImpl()
        }
        DIContainer.register(type: OnBoardingPresentableFactory.self) {
            return OnBoardingModalFactoryImpl()
        }
        DIContainer.register(type: LoginFactory.self) {
            return LoginFactoryImpl(
                termsAgreementsFactory: DIContainer.resolve(type: TermsAgreementFactory.self),
                appleLoginUseCase: DIContainer.resolve(type: SocialLoginUseCase.self, name: "apple"),
                kakaoLoginUseCase: DIContainer.resolve(type: SocialLoginUseCase.self, name: "kakao")
            )
        }
    }
}
