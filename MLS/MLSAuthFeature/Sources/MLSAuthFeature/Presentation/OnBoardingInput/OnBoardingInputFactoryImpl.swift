import MLSAppFeatureInterface
import MLSAuthFeatureInterface
import MLSCore

public struct OnBoardingInputFactoryImpl: OnBoardingInputFactory {
    private let checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    private let checkValidLevelUseCase: CheckValidLevelUseCase
    private let authRepository: AuthAPIRepository
    private let onBoardingNotificationFactory: OnBoardingNotificationFactory
    private let appCoordinator: () -> AppCoordinatorProtocol

    public init(
        checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase,
        checkValidLevelUseCase: CheckValidLevelUseCase,
        authRepository: AuthAPIRepository,
        onBoardingNotificationFactory: OnBoardingNotificationFactory,
        appCoordinator: @escaping () -> AppCoordinatorProtocol
    ) {
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
        self.authRepository = authRepository
        self.onBoardingNotificationFactory = onBoardingNotificationFactory
        self.appCoordinator = appCoordinator
    }

    public func make() -> BaseViewController {
        let viewController = OnBoardingInputViewController(onBoardingNotificationFactory: onBoardingNotificationFactory, appCoordinator: appCoordinator())
        viewController.isBottomTabbarHidden = true
        viewController.reactor = OnBoardingInputReactor(
            checkEmptyUseCase: checkEmptyUseCase,
            checkValidLevelUseCase: checkValidLevelUseCase,
            authRepository: authRepository
        )
        return viewController
    }
}
