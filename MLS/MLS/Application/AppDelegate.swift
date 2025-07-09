import UIKit
import UserNotifications
import os

import AuthFeature
import AuthFeatureInterface
import BaseFeature
import Core
import Data
import DataMock
import DesignSystem
import Domain
import DomainInterface
import DictionaryFeature
import DictionaryFeatureInterface

import Firebase
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: - UserNotification Set
        FirebaseApp.configure() // Firebase Set
        Messaging.messaging().delegate = self // 파이어베이스 Meesaging 설정

        UNUserNotificationCenter.current().delegate = self // NotificationCenter Delegate
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications() // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴

        // MARK: - Modules Set
        ImageLoader.shared.configure.diskCacheCountLimit = 10 // ImageLoader
        FontManager.registerFonts() // FontManager

        // MARK: - KakaoSDK Set
        let kakaoNativeAppKey: String = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        
        registerDependencies()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

// MARK: - Notification Delegate, MessagingDelegate
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.list, .banner])
    }

    // 파이어베이스 MessagingDelegate 설정
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        let tokenUseCase = DIContainer.resolve(type: SaveTokenToLocalUseCase.self)
        let result = tokenUseCase.execute(type: .fcmToken, value: fcmToken ?? "")

        switch result {
        case .success:
            os_log("✅ fcmToken Save Success Token: \(fcmToken ?? "")")
        case .failure:
            os_log("⚠️ fcmToken Save Failure")
        }
    }
}

// MARK: - registerDependencies
private extension AppDelegate {
    func registerDependencies() {
        registerProvider()
        registerRepository()
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

    func registerRepository() {
        DIContainer.register(type: AuthAPIRepository.self) {
            return AuthAPIRepositoryImpl(provider: DIContainer.resolve(type: NetworkProvider.self))
        }
        DIContainer.register(type: TokenRepository.self) {
            return KeyChainRepositoryImpl()
        }
    }

    func registerUseCase() {
        DIContainer.register(type: FetchSocialCredentialUseCase.self, name: "kakao") {
            let provider = DIContainer.resolve(type: SocialAuthenticatableProvider.self, name: "kakao")
            return SocialLoginUseCaseImpl(provider: provider)
        }
        DIContainer.register(type: FetchSocialCredentialUseCase.self, name: "apple") {
            let provider = DIContainer.resolve(type: SocialAuthenticatableProvider.self, name: "apple")
            return SocialLoginUseCaseImpl(provider: provider)
        }
        DIContainer.register(type: CheckEmptyLevelAndRoleUseCase.self) {
            return CheckEmptyLevelAndRoleUseCaseImpl()
        }
        DIContainer.register(type: CheckValidLevelUseCase.self) {
            return CheckValidLevelUseCaseImpl()
        }
        DIContainer.register(type: FetchJobListUseCase.self) {
            return FetchJobListUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: LoginWithAppleUseCase.self) {
            return LoginWithAppleUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: LoginWithKakaoUseCase.self) {
            return LoginWithKakaoUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: SignUpWithAppleUseCase.self) {
            return SignUpWithAppleUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: SignUpWithKakaoUseCase.self) {
            return SignUpWithKakaoUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: UpdateUserInfoUseCase.self) {
            return UpdateUserInfoUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: ReissueUseCase.self) {
            return ReissueUseCaseImpl(repository: DIContainer.resolve(type: AuthAPIRepository.self))
        }
        DIContainer.register(type: FetchTokenFromLocalUseCase.self) {
            return FetchTokenFromLocalUseCaseImpl(repository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: SaveTokenToLocalUseCase.self) {
            return SaveTokenToLocalUseCaseImpl(repository: DIContainer.resolve(type: TokenRepository.self))
        }
        DIContainer.register(type: DeleteTokenFromLocalUseCase.self) {
            return DeleteTokenFromLocalUseCaseImpl(repository: DIContainer.resolve(type: TokenRepository.self))
        }
    }

    func registerFactory() {
        DIContainer.register(type: OnBoardingInputFactory.self) {
            return OnBoardingInputFactoryImpl(
                checkEmptyUseCase: DIContainer.resolve(type: CheckEmptyLevelAndRoleUseCase.self),
                checkValidLevelUseCase: DIContainer.resolve(type: CheckValidLevelUseCase.self),
                fetchJobListUseCase: DIContainer.resolve(type: FetchJobListUseCase.self),
                updateUserInfoUseCase: DIContainer.resolve(type: UpdateUserInfoUseCase.self)
            )
        }
        DIContainer.register(type: OnBoardingQuestionFactory.self) {
            return OnBoardingQuestionFactoryImpl(
                onBoardingInputFactory: DIContainer.resolve(type: OnBoardingInputFactory.self)
            )
        }
        DIContainer.register(type: TermsAgreementFactory.self) {
            return TermsAgreementFactoryImpl(
                onBoardingQuestionFactory: DIContainer.resolve(type: OnBoardingQuestionFactory.self),
                signUpWithKakaoUseCase: DIContainer.resolve(type: SignUpWithKakaoUseCase.self),
                signUpWithAppleUseCase: DIContainer.resolve(type: SignUpWithAppleUseCase.self),
                saveTokenUseCase: DIContainer.resolve(type: SaveTokenToLocalUseCase.self),
                fetchTokenUseCase: DIContainer.resolve(type: FetchTokenFromLocalUseCase.self)
            )
        }
        DIContainer.register(type: LoginFactory.self) {
            return LoginFactoryImpl(
                termsAgreementsFactory: DIContainer.resolve(type: TermsAgreementFactory.self),
                appleLoginUseCase: DIContainer.resolve(type: FetchSocialCredentialUseCase.self, name: "apple"),
                kakaoLoginUseCase: DIContainer.resolve(type: FetchSocialCredentialUseCase.self, name: "kakao"),
                loginWithAppleUseCase: DIContainer.resolve(type: LoginWithAppleUseCase.self),
                loginWithKakaoUseCase: DIContainer.resolve(type: LoginWithKakaoUseCase.self),
                fetchTokenUseCase: DIContainer.resolve(type: FetchTokenFromLocalUseCase.self)
            )
        }
        DIContainer.register(type: NotificationFactory.self) {
            return NotificationFactoryImpl(loginFactory: DIContainer.resolve(type: LoginFactory.self))
        }
    }
}
