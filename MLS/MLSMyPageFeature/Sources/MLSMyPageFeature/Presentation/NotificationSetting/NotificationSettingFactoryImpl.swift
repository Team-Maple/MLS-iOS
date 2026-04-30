import MLSAuthFeatureInterface
import MLSCore
import MLSMyPageFeatureInterface

public final class NotificationSettingFactoryImpl: NotificationSettingFactory {
    private let notificationRepository: NotificationPermissionRepository
    private let authRepository: AuthAPIRepository

    public init(notificationRepository: NotificationPermissionRepository, authRepository: AuthAPIRepository) {
        self.notificationRepository = notificationRepository
        self.authRepository = authRepository
    }

    public func make(isAgreeEventNotification: Bool, isAgreeNoticeNotification: Bool, isAgreePatchNoteNotification: Bool) -> BaseViewController {
        let viewController = NotificationSettingViewController(
            reactor: NotificationSettingReactor(
                notificationRepository: notificationRepository,
                authRepository: authRepository,
                isAgreeEventNotification: isAgreeEventNotification,
                isAgreeNoticeNotification: isAgreeNoticeNotification,
                isAgreePatchNoteNotification: isAgreePatchNoteNotification
            )
        )
        return viewController
    }
}
