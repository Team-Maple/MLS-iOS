import BaseFeature
import DictionaryFeatureInterface
import DomainInterface
import MyPageFeatureInterface

public final class DictionaryNotificationFactoryImpl: DictionaryNotificationFactory {
    private let notificationSettingFactory: NotificationSettingFactory

    private let fetchAllAlarmUseCase: FetchAllAlarmUseCase
    private let fetchProfileUseCase: FetchProfileUseCase
    private let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
    private let setReadUseCase: SetReadUseCase

    public init(
        notificationSettingFactory: NotificationSettingFactory,
        fetchAllAlarmUseCase: FetchAllAlarmUseCase,
        fetchProfileUseCase: FetchProfileUseCase,
        checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase,
        setReadUseCase: SetReadUseCase
    ) {
        self.notificationSettingFactory = notificationSettingFactory
        self.fetchAllAlarmUseCase = fetchAllAlarmUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
        self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
        self.setReadUseCase = setReadUseCase
    }

    public func make() -> BaseViewController {
        let reactor = DictionaryNotificationReactor(fetchAllAlarmUseCase: fetchAllAlarmUseCase, fetchProfileUseCase: fetchProfileUseCase, checkNotificationPermissionUseCase: checkNotificationPermissionUseCase, setReadUseCase: setReadUseCase)
        let viewController = DictionaryNotificationViewController(notificationSettingFactory: notificationSettingFactory)
        viewController.reactor = reactor
        return viewController
    }
}
