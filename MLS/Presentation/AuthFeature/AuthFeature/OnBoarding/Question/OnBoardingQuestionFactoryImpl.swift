import BaseFeature
import AuthFeatureInterface
import Domain

public struct OnBoardingQuestionFactoryImpl: OnBoardingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = OnBoardingInputViewController(factory: OnBoardingInputFactoryImpl())
        viewController.reactor = OnBoardingInputReactor(useCase: OnBoardingInputUseCaseImpl(repository: OnBoardingInputRepositoryImpl))
        return viewController
    }
}
