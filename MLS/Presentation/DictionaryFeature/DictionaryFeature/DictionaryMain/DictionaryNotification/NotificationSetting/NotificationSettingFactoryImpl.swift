import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class NotificationSettingFactoryImpl: NotificationSettingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let reactor = NotificationSettingReactor()
        let viewController = NotificationSettingViewController()
        viewController.reactor = reactor
        return viewController
    }
}
