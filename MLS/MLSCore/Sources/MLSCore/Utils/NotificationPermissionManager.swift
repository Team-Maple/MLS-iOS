import UIKit
import UserNotifications

public final class NotificationPermissionManager: @unchecked Sendable {

    public static let shared = NotificationPermissionManager()
    private init() {}

    public func getStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }

    public func requestIfNeeded(completion: ((Bool) -> Void)? = nil) {
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
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                        completion?(true)
                    } else {
                        completion?(false)
                    }
                }

            case .authorized, .provisional:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                completion?(true)

            case .denied:
                completion?(false)

            default:
                completion?(false)
            }
        }
    }
}
