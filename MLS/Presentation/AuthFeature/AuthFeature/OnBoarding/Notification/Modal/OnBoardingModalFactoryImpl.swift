import AuthFeatureInterface
import BaseFeature

public struct OnBoardingModalFactoryImpl: OnBoardingModalFactory {
    public init() {}

    public func make() -> BaseViewController & ModalPresentable {
        let viewController = OnBoardingModalViewController()
        viewController.reactor = OnBoardingModalReactor()
        return viewController
    }
}
