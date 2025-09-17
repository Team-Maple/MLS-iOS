import BaseFeature
import MyPageFeatureInterface

public final class MyPageMainFactoryImpl: MyPageMainFactory {
    private let setProfileFactory: SetProfileFactory
    private let customerSupportFactory: CustomerSupportFactory
    private let notificationSettingFactory: NotificationSettingFactory

    public init(setProfileFactory: SetProfileFactory, customerSupportFactory: CustomerSupportFactory, notificationSettingFactory: NotificationSettingFactory) {
        self.setProfileFactory = setProfileFactory
        self.customerSupportFactory = customerSupportFactory
        self.notificationSettingFactory = notificationSettingFactory
    }

    public func make() -> BaseViewController {
        let viewController = MyPageMainViewController(setProfileFactory: setProfileFactory, customerSupportFactory: customerSupportFactory, notificationSettingFactory: notificationSettingFactory)
        viewController.reactor = MyPageMainReactor()
        return viewController
    }
}
