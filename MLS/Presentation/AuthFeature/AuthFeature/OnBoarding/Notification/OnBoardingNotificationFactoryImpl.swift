import BaseFeature
import AuthFeatureInterface

public struct OnBoardingNotificationFactoryImpl: OnBoardingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = ModalViewController()
        viewController.reactor = ModalReactor()
        return viewController
    }
}
