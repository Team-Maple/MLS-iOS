import BaseFeature
import DomainInterface
import MyPageFeatureInterface

public final class NotificationSettingFactoryImpl: NotificationSettingFactory {
    private let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
    private let updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase
    
    public init(checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase, updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase) {
        self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
        self.updateNotificationAgreementUseCase = updateNotificationAgreementUseCase
    }

    public func make() -> BaseViewController {
        let viewController = NotificationSettingViewController(reactor: NotificationSettingReactor(checkNotificationPermissionUseCase: checkNotificationPermissionUseCase, updateNotificationAgreementUseCase: updateNotificationAgreementUseCase))
        return viewController
    }
}
