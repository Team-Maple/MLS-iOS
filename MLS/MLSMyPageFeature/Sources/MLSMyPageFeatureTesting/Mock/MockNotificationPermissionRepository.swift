import UserNotifications

import MLSMyPageFeatureInterface

import RxSwift

public final class MockNotificationPermissionRepository: NotificationPermissionRepository {
    public var fetchAuthorizationStatusResult = false
    
    public init() {}

    public func fetchAuthorizationStatus() -> Single<Bool> {
        Single.create { single in
            single(.success(self.fetchAuthorizationStatusResult))
            return Disposables.create()
        }
    }
}
