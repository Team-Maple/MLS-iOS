import AuthFeatureInterface
import BaseFeature

public struct NotificationFactoryImpl: NotificationFactory {

    private let loginFactory: LoginFactory

    public init(loginFactory: LoginFactory) {
        self.loginFactory = loginFactory
    }

    public func make() -> BaseViewController {
        let viewController = NotificationViewController(factory: loginFactory)
        viewController.reactor = NotificationReactor()
        return viewController
    }
}
