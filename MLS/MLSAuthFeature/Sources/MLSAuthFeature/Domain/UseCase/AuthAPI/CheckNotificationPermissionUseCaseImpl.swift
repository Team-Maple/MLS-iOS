import Foundation
import UserNotifications


import RxSwift

public final class CheckNotificationPermissionUseCaseImpl: CheckNotificationPermissionUseCase {
    public init() {}

    public func execute() -> Single<Bool> {
        return Single.create { observer in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    observer(.success(true))
                default:
                    observer(.success(false))
                }
            }
            return Disposables.create()
        }
    }
}
