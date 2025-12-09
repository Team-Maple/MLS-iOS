import UIKit
import UserNotifications

public final class NotificationPermissionManager {

    public static let shared = NotificationPermissionManager()
    private init() {}

    public func getStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }

    @discardableResult
    public func requestIfNeeded(
        application: UIApplication = .shared,
        completion: ((Bool) -> Void)? = nil
    ) -> Void {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                        completion?(false)
                        return
                    }
                    if granted {
                        DispatchQueue.main.async {
                            application.registerForRemoteNotifications()
                        }
                        print("알림 권한 허용")
                        completion?(true)
                    } else {
                        print("알림 권한 거부")
                        completion?(false)
                    }
                }

            case .authorized, .provisional:
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
                completion?(true)

            case .denied:
                print("🚫 알림 권한 거부 상태입니다. 설정에서 변경해야 함")
                completion?(false)

            @unknown default:
                completion?(false)
            }
        }
    }
}
