import AuthFeatureInterface
import BaseFeature
import DomainInterface
import MyPageFeatureInterface

public final class MyPageMainFactoryImpl: MyPageMainFactory {
    private let loginFactory: LoginFactory
    private let setProfileFactory: SetProfileFactory
    private let customerSupportFactory: CustomerSupportFactory
    private let notificationSettingFactory: NotificationSettingFactory
    private let setCharacterFactory: SetCharacterFactory
    private let fetchProfileUseCase: FetchProfileUseCase

    public init(
        loginFactory: LoginFactory,
        setProfileFactory: SetProfileFactory,
        customerSupportFactory: CustomerSupportFactory,
        notificationSettingFactory: NotificationSettingFactory,
        setCharacterFactory: SetCharacterFactory,
        fetchProfileUseCase: FetchProfileUseCase
    ) {
        self.loginFactory = loginFactory
        self.setProfileFactory = setProfileFactory
        self.customerSupportFactory = customerSupportFactory
        self.notificationSettingFactory = notificationSettingFactory
        self.setCharacterFactory = setCharacterFactory
        self.fetchProfileUseCase = fetchProfileUseCase
    }

    public func make() -> BaseViewController {
        let viewController = MyPageMainViewController(
            setProfileFactory: setProfileFactory,
            customerSupportFactory: customerSupportFactory,
            notificationSettingFactory: notificationSettingFactory,
            setCharacterFactory: setCharacterFactory,
            loginFactory: loginFactory
        )
        viewController.reactor = MyPageMainReactor(fetchProfileUseCase: fetchProfileUseCase)
        return viewController
    }
}
