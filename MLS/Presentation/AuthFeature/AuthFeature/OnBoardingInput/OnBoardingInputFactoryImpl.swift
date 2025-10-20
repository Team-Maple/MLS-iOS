import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct OnBoardingInputFactoryImpl: OnBoardingInputFactory {
    private let checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    private let checkValidLevelUseCase: CheckValidLevelUseCase
    private let fetchJobListUseCase: FetchJobListUseCase
    private let updateUserInfoUseCase: UpdateUserInfoUseCase
    private let onBoardingNotificationFactory: OnBoardingNotificationFactory

    public init(
        checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase,
        checkValidLevelUseCase: CheckValidLevelUseCase,
        fetchJobListUseCase: FetchJobListUseCase,
        updateUserInfoUseCase: UpdateUserInfoUseCase,
        onBoardingNotificationFactory: OnBoardingNotificationFactory
    ) {
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
        self.fetchJobListUseCase = fetchJobListUseCase
        self.updateUserInfoUseCase = updateUserInfoUseCase
        self.onBoardingNotificationFactory = onBoardingNotificationFactory
    }

    public func make() -> BaseViewController {
        let viewController = OnBoardingInputViewController(onBoardingNotificationFactory: onBoardingNotificationFactory)
        viewController.reactor = OnBoardingInputReactor(
            checkEmptyUseCase: checkEmptyUseCase,
            checkValidLevelUseCase: checkValidLevelUseCase,
            fetchJobListUseCase: fetchJobListUseCase
        )
        return viewController
    }
}
