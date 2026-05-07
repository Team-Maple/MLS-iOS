import UserNotifications

import MLSMyPageFeatureInterface

import RxSwift

public final class NotificationPermissionRepositoryImpl: NotificationPermissionRepository {
    public init() {}

    public func fetchAuthorizationStatus() -> Single<Bool> {
        Single.create { single in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                single(.success(settings.authorizationStatus == .authorized))
            }

            return Disposables.create()
        }
    }
}
