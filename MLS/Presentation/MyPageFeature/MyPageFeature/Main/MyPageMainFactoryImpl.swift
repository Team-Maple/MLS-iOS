import BaseFeature
import MyPageFeatureInterface

public final class MyPageMainFactoryImpl: MyPageMainFactory {
    private let setProfileFactory: SetProfileFactory
    private let customerSupportFactory: CustomerSupportFactory
    private let notificationSettingFactory: NotificationSettingFactory
    private let setCharacterFactory: SetCharacterFactory

    public init(setProfileFactory: SetProfileFactory, customerSupportFactory: CustomerSupportFactory, notificationSettingFactory: NotificationSettingFactory, setCharacterFactory: SetCharacterFactory) {
        self.setProfileFactory = setProfileFactory
        self.customerSupportFactory = customerSupportFactory
        self.notificationSettingFactory = notificationSettingFactory
        self.setCharacterFactory = setCharacterFactory
    }

    public func make() -> BaseViewController {
        let viewController = MyPageMainViewController(setProfileFactory: setProfileFactory, customerSupportFactory: customerSupportFactory, notificationSettingFactory: notificationSettingFactory, setCharacterFactory: setCharacterFactory)
        viewController.reactor = MyPageMainReactor()
        return viewController
    }
}
