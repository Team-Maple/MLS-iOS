import AuthFeatureInterface
import BaseFeature

public struct OnBoardingNotificationFactoryImpl: OnBoardingNotificationFactory {
    private let onBoardingNotificationSheetFactory: OnBoardingNotificationSheetFactory
    private let appCoordinator: () -> AppCoordinatorProtocol

    public init(onBoardingNotificationSheetFactory: OnBoardingNotificationSheetFactory, appCoordinator: @escaping () -> AppCoordinatorProtocol) {
        self.onBoardingNotificationSheetFactory = onBoardingNotificationSheetFactory
        self.appCoordinator = appCoordinator
    }

    public func make(selectedLevel: Int, selectedJobID: Int) -> BaseViewController {
        let viewController = OnBoardingNotificationViewController(onBoardingNotificationSheetFactory: onBoardingNotificationSheetFactory, appCoordinator: appCoordinator())
        viewController.isBottomTabbarHidden = true
        viewController.reactor = OnBoardingNotificationReactor(selectedLevel: selectedLevel, selectedJobID: selectedJobID)
        return viewController
    }
}
