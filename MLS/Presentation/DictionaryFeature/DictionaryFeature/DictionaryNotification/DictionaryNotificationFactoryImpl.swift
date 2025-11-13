import BaseFeature
import DictionaryFeatureInterface
import DomainInterface
import MyPageFeatureInterface

public final class DictionaryNotificationFactoryImpl: DictionaryNotificationFactory {
    private let notificationSettingFactory: NotificationSettingFactory
    private let fetchAllAlarmUseCase: FetchAllAlarmUseCase
    private let fetchProfileUseCase: FetchProfileUseCase

    public init(notificationSettingFactory: NotificationSettingFactory, fetchAllAlarmUseCase: FetchAllAlarmUseCase, fetchProfileUseCase: FetchProfileUseCase) {
        self.notificationSettingFactory = notificationSettingFactory
        self.fetchAllAlarmUseCase = fetchAllAlarmUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
    }

    public func make() -> BaseViewController {
        let reactor = DictionaryNotificationReactor(fetchAllAlarmUseCase: fetchAllAlarmUseCase, fetchProfileUseCase: fetchProfileUseCase)
        let viewController = DictionaryNotificationViewController(notificationSettingFactory: notificationSettingFactory)
        viewController.reactor = reactor
        return viewController
    }
}
