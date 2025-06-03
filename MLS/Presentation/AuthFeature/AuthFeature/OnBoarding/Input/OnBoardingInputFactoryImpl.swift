import AuthFeatureInterface
import BaseFeature
import Core
import DomainInterface

public struct OnBoardingInputFactoryImpl: OnBoardingFactory {
    private let checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    private let checkValidLevelUseCase: CheckValidLevelUseCase
    
    public init(checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase, checkValidLevelUseCase: CheckValidLevelUseCase) {
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
    }

    public func make() -> BaseViewController {
        let viewController = OnBoardingInputViewController(factory: DIContainer.resolve(type: OnBoardingFactory.self, name: "onBoardingNotification"))
        viewController.reactor = OnBoardingInputReactor(checkEmptyUseCase: checkEmptyUseCase, checkValidLevelUseCase: checkValidLevelUseCase)
        return viewController
    }
}
