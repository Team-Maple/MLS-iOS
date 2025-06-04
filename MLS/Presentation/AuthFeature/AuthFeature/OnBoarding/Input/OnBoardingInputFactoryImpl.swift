import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct OnBoardingInputFactoryImpl: OnBoardingInputFactory {

    private let checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    private let checkValidLevelUseCase: CheckValidLevelUseCase
    private let onBoardingNotificationFactory: OnBoardingNotificationFactory

    public init(
        checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase,
        checkValidLevelUseCase: CheckValidLevelUseCase,
        onBoardingNotificationFactory: OnBoardingNotificationFactory
    ) {
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
        self.onBoardingNotificationFactory = onBoardingNotificationFactory
    }

    public func make() -> BaseViewController {
        let viewController = OnBoardingInputViewController(factory: onBoardingNotificationFactory)
        viewController.reactor = OnBoardingInputReactor(checkEmptyUseCase: checkEmptyUseCase, checkValidLevelUseCase: checkValidLevelUseCase)
        return viewController
    }
}
