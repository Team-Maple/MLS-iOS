import AuthFeatureInterface
import BaseFeature

public struct OnBoardingQuestionFactoryImpl: OnBoardingQuestionFactory {

    private let onBoardingInputFactory: OnBoardingInputFactory

    public init(onBoardingInputFactory: OnBoardingInputFactory) {
        self.onBoardingInputFactory = onBoardingInputFactory
    }

    public func make() -> BaseViewController {
        let viewController = OnBoardingQuestionViewController(factory: onBoardingInputFactory)
        viewController.isBottomTabbarHidden = true
        viewController.reactor = OnBoardingQuestionReactor()
        return viewController
    }
}
