import AuthFeatureInterface
import BaseFeature
import Core
import Domain
import DomainInterface

public struct OnBoardingQuestionFactoryImpl: OnBoardingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = OnBoardingQuestionViewController(factory: DIContainer.resolve(type: OnBoardingFactory.self, name: "onBoardingInput"))
        viewController.reactor = OnBoardingQuestionReactor()
        return viewController
    }
}
