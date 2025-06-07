import AuthFeatureInterface
import BaseFeature
import DomainInterface

public struct OnBoardingInputFactoryImpl: OnBoardingInputFactory {

    private let onBoardingNotificationFactory: OnBoardingNotificationFactory

    private let checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    private let checkValidLevelUseCase: CheckValidLevelUseCase
    private let fetchJobListUseCase: FetchJobListUseCase
    private let updateUserInfoUseCase: UpdateUserInfoUseCase

    public init(
        onBoardingNotificationFactory: OnBoardingNotificationFactory,
        checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase,
        checkValidLevelUseCase: CheckValidLevelUseCase,
        fetchJobListUseCase: FetchJobListUseCase,
        updateUserInfoUseCase: UpdateUserInfoUseCase
    ) {
        self.onBoardingNotificationFactory = onBoardingNotificationFactory
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
        self.fetchJobListUseCase = fetchJobListUseCase
        self.updateUserInfoUseCase = updateUserInfoUseCase
    }

    public func make() -> BaseViewController {
        let viewController = OnBoardingInputViewController(factory: onBoardingNotificationFactory)
        viewController.reactor = OnBoardingInputReactor(
            checkEmptyUseCase: checkEmptyUseCase,
            checkValidLevelUseCase: checkValidLevelUseCase,
            fetchJobListUseCase: fetchJobListUseCase,
            updateUserInfoUseCase: updateUserInfoUseCase
        )
        return viewController
    }
}
