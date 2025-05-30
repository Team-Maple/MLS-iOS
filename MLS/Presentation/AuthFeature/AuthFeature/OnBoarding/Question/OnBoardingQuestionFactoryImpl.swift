import AuthFeatureInterface
import BaseFeature
import Core
import Domain
import DomainInterface

public struct OnBoardingQuestionFactoryImpl: OnBoardingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = OnBoardingInputViewController(factory: DIContainer.resolve(type: OnBoardingFactory.self, name: "onBoardingQuestion"))
        viewController.reactor = OnBoardingInputReactor(useCase: OnBoardingInputUseCaseImpl(repository: DIContainer.resolve(type: OnBoardingInputRepository.self)))
        return viewController
    }
}
