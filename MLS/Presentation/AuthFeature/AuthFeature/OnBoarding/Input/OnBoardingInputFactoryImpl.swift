import AuthFeatureInterface
import BaseFeature
import Core
import DomainInterface

public struct OnBoardingInputFactoryImpl: OnBoardingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = OnBoardingInputViewController(factory: DIContainer.resolve(type: OnBoardingFactory.self, name: "onBoardingNotification"))
        viewController.reactor = OnBoardingInputReactor(checkEmptyUseCase: DIContainer.resolve(type: CheckEmptyLevelAndRoleUseCase.self), checkValidLevelUseCase: DIContainer.resolve(type: CheckValidLevelUseCase.self))
        return viewController
    }
}
