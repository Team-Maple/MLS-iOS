import BaseFeature
import AuthFeatureInterface

public struct OnBoardingInputFactoryImpl: OnBoardingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = OnBoardingNotificationViewController()
        viewController.reactor = OnBoardingNotificationReactor()
        return viewController
    }
}
