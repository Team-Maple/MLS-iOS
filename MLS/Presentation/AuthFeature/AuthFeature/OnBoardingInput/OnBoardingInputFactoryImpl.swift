import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct OnBoardingInputFactoryImpl: OnBoardingInputFactory {
    private let checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    private let checkValidLevelUseCase: CheckValidLevelUseCase
    private let fetchJobListUseCase: FetchJobListUseCase
    private let updateUserInfoUseCase: UpdateUserInfoUseCase
    private let onBoadingNotificationFactory: OnBoadingNotificationFactory

    public init(
        checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase,
        checkValidLevelUseCase: CheckValidLevelUseCase,
        fetchJobListUseCase: FetchJobListUseCase,
        updateUserInfoUseCase: UpdateUserInfoUseCase,
        onBoadingNotificationFactory: OnBoadingNotificationFactory
    ) {
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
        self.fetchJobListUseCase = fetchJobListUseCase
        self.updateUserInfoUseCase = updateUserInfoUseCase
        self.onBoadingNotificationFactory = onBoadingNotificationFactory
    }

    public func make() -> BaseViewController {
        let viewController = OnBoardingInputViewController(onBoadingNotificationFactory: onBoadingNotificationFactory)
        viewController.reactor = OnBoardingInputReactor(
            checkEmptyUseCase: checkEmptyUseCase,
            checkValidLevelUseCase: checkValidLevelUseCase,
            fetchJobListUseCase: fetchJobListUseCase,
            updateUserInfoUseCase: updateUserInfoUseCase
        )
        return viewController
    }
}
