// swiftlint:disable line_length

import UIKit

import MLSCore
import MLSDesignSystem

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ImageLoader.shared.configure.diskCacheCountLimit = 10
        FontManager.registerFonts()

        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if let error = error {
                        print("알림 권한 요청 실패: \(error)")
                    } else {
                        print("알림 권한 허용 여부: \(granted)")
                    }
                }
            case .denied:
                print("사용자가 알림 권한 거부")
            case .authorized, .provisional, .ephemeral:
                print("알림 권한 이미 허용됨")
            @unknown default:
                break
            }
        }

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
