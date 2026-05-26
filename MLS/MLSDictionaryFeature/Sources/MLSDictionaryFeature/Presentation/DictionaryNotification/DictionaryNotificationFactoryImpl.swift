import MLSCore
import MLSDictionaryFeatureInterface
import MLSMyPageFeatureInterface

public final class DictionaryNotificationFactoryImpl: DictionaryNotificationFactory {
    private let notificationSettingFactory: NotificationSettingFactory

    private let fetchProfileUseCase: FetchProfileUseCase
    private let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
    private let alarmRepository: AlarmRepository

    public init(
        notificationSettingFactory: NotificationSettingFactory,
        fetchProfileUseCase: FetchProfileUseCase,
        checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase,
        alarmRepository: AlarmRepository
    ) {
        self.notificationSettingFactory = notificationSettingFactory
        self.fetchProfileUseCase = fetchProfileUseCase
        self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
        self.alarmRepository = alarmRepository
    }

    public func make() -> BaseViewController {
        let reactor = DictionaryNotificationReactor(fetchProfileUseCase: fetchProfileUseCase, checkNotificationPermissionUseCase: checkNotificationPermissionUseCase, alarmRepository: alarmRepository)
        let viewController = DictionaryNotificationViewController(notificationSettingFactory: notificationSettingFactory)
        viewController.reactor = reactor
        return viewController
    }
}
