import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryNotificationFactoryImpl: DictionaryNotificationFactory {
    private let fetchNotificationUseCase: FetchNotificationUseCase
    private let notificationSettingFactory: NotificationSettingFactory
    
    public init(fetchNotificationUseCase: FetchNotificationUseCase, notificationSettingFactory: NotificationSettingFactory) {
        self.fetchNotificationUseCase = fetchNotificationUseCase
        self.notificationSettingFactory = notificationSettingFactory
    }

    public func make() -> BaseViewController {
        let reactor = DictionaryNotificationReactor(fetchNotificationUseCase: fetchNotificationUseCase)
        let viewController = DictionaryNotificationViewController(notificationSettingFactory: notificationSettingFactory)
        viewController.reactor = reactor
        return viewController
    }
}
