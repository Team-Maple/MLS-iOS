import UserNotifications

import DomainInterface

import RxSwift

public final class CheckNotificationPermissionUseCaseImpl: CheckNotificationPermissionUseCase {
    public init() {}

    public func execute() -> Single<Bool> {
        return Single.create { single in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    single(.success(true))
                default:
                    single(.success(false))
                }
            }
            return Disposables.create()
        }
    }
}
