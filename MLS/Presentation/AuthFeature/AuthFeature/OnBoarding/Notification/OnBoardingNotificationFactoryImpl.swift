import AuthFeatureInterface
import BaseFeature

public struct OnBoardingNotificationFactoryImpl: OnBoardingNotificationFactory {

    private let onBoardingModalFactory: OnBoardingModalFactory

    public init(onBoardingModalFactory: OnBoardingModalFactory) {
        self.onBoardingModalFactory = onBoardingModalFactory
    }

    public func make() -> BaseViewController {
        let viewController = OnBoardingNotificationViewController(factory: onBoardingModalFactory)
        viewController.reactor = OnBoardingNotificationReactor()
        return viewController
    }
}
