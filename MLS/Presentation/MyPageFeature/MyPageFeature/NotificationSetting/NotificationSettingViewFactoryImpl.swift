import BaseFeature
import DomainInterface
import MyPageFeatureInterface

public final class NotificationSettingViewFactoryImpl: NotificationSettingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = NotificationSettingViewController()
        return viewController
    }
}
