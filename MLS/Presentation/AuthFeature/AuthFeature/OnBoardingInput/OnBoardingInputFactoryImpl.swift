import AuthFeatureInterface
import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public struct OnBoardingInputFactoryImpl: OnBoardingInputFactory {
    private let checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    private let checkValidLevelUseCase: CheckValidLevelUseCase
    private let fetchJobListUseCase: FetchJobListUseCase
    private let updateUserInfoUseCase: UpdateUserInfoUseCase
    private let onBoardingNotificationFactory: OnBoardingNotificationFactory
    private let appCoordinator: () -> AppCoordinatorProtocol

    public init(
        checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase,
        checkValidLevelUseCase: CheckValidLevelUseCase,
        fetchJobListUseCase: FetchJobListUseCase,
        updateUserInfoUseCase: UpdateUserInfoUseCase,
        onBoardingNotificationFactory: OnBoardingNotificationFactory,
        appCoordinator: @escaping () -> AppCoordinatorProtocol
    ) {
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
        self.fetchJobListUseCase = fetchJobListUseCase
        self.updateUserInfoUseCase = updateUserInfoUseCase
        self.onBoardingNotificationFactory = onBoardingNotificationFactory
        self.appCoordinator = appCoordinator
    }

    public func make() -> BaseViewController {
        let viewController = OnBoardingInputViewController(onBoardingNotificationFactory: onBoardingNotificationFactory, appCoordinator: appCoordinator())
        viewController.isBottomTabbarHidden = true
        viewController.reactor = OnBoardingInputReactor(
            checkEmptyUseCase: checkEmptyUseCase,
            checkValidLevelUseCase: checkValidLevelUseCase,
            fetchJobListUseCase: fetchJobListUseCase
        )
        return viewController
    }
}
