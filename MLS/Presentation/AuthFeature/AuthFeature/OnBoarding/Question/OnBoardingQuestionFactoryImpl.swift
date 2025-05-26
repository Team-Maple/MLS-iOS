import BaseFeature
import AuthFeatureInterface

public struct OnBoardingQuestionFactoryImpl: OnBoardingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = OnBoardingInputViewController(factory: OnBoardingInputFactoryImpl())
        viewController.reactor = OnBoardingInputReactor()
        return viewController
    }
}
