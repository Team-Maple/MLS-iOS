import BaseFeature
import MyPageFeatureInterface
import DomainInterface

public final class NotificationSettingViewFactoryImpl: NotificationSettingFactory {
    public init() {}
    
    public func make() -> BaseViewController {
        let viewController = NotificationSettingViewController()
        return viewController
    }
}
