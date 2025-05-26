import BaseFeature
import AuthFeatureInterface

public struct OnBoardingInputFactoryImpl: OnBoardingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = OnBoardingNotificationViewController(factory: OnBoardingNotificationFactoryImpl())
        viewController.reactor = OnBoardingNotificationReactor()
        return viewController
    }
}
