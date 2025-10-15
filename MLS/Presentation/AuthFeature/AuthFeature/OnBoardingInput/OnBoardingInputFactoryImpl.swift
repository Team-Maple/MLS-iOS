import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct OnBoardingInputFactoryImpl: OnBoardingInputFactory {
    private let checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    private let checkValidLevelUseCase: CheckValidLevelUseCase
    private let fetchJobListUseCase: FetchJobListUseCase
    private let onBoadingNotificationFactory: OnBoadingNotificationFactory

    public init(
        checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase,
        checkValidLevelUseCase: CheckValidLevelUseCase,
        fetchJobListUseCase: FetchJobListUseCase,
        onBoadingNotificationFactory: OnBoadingNotificationFactory
    ) {
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
        self.fetchJobListUseCase = fetchJobListUseCase
        self.onBoadingNotificationFactory = onBoadingNotificationFactory
    }

    public func make() -> BaseViewController {
        let viewController = OnBoardingInputViewController(onBoadingNotificationFactory: onBoadingNotificationFactory)
        viewController.reactor = OnBoardingInputReactor(
            checkEmptyUseCase: checkEmptyUseCase,
            checkValidLevelUseCase: checkValidLevelUseCase,
            fetchJobListUseCase: fetchJobListUseCase
        )
        return viewController
    }
}
