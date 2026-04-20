import MLSAuthFeatureInterface
import MLSCore
import MLSDesignSystem

public struct OnBoardingNotificationSheetFactoryImpl: OnBoardingNotificationSheetFactory {
    private let authRepository: AuthAPIRepository
    private let appCoordinator: () -> AppCoordinatorProtocol

    public init(
        authRepository: AuthAPIRepository,
        appCoordinator: @escaping () -> AppCoordinatorProtocol
    ) {
        self.authRepository = authRepository
        self.appCoordinator = appCoordinator
    }

    public func make(selectedLevel: Int, selectedJobID: Int) -> BaseViewController & ModalPresentable {
        let viewController = OnBoardingNotificationSheetViewController(appCoordinator: appCoordinator())
        viewController.isBottomTabbarHidden = true
        viewController.reactor = OnBoardingNotificationSheetReactor(
            selectedLevel: selectedLevel,
            selectedJobID: selectedJobID,
            authRepository: authRepository
        )
        return viewController
    }
}
