import os
import UIKit
import UserNotifications

import MLSAppFeature
import MLSCore
import MLSDesignSystem

import Firebase
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let applauncher = AppLauncher()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        // MARK: - UserNotification Set
        FirebaseApp.configure() // Firebase Set
        Messaging.messaging().delegate = self // 파이어베이스 Meesaging 설정
        UNUserNotificationCenter.current().delegate = self // NotificationCenter Delegate

        // MARK: - Modules Set
        ImageLoader.shared.configure.diskCacheCountLimit = 10 // ImageLoader
        FontManager.registerFonts() // FontManager
        applauncher.register()

        // MARK: - KakaoSDK Set
        let kakaoNativeAppKey: String =
            Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String ?? ""
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}

// MARK: - Notification Delegate, MessagingDelegate
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        completionHandler([.list, .banner])
    }

    // 파이어베이스 MessagingDelegate 설정
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        let tokenLauncher = TokenLauncher()
        guard let fcmToken = fcmToken else {
            os_log("FCM token is nil")
            return
        }
        tokenLauncher.didReceiveFCMToken(fcmToken)
    }
}
