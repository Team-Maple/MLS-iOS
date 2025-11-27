import AuthFeatureInterface
import BaseFeature
import DictionaryFeatureInterface

public struct OnBoardingNotificationFactoryImpl: OnBoardingNotificationFactory {
    private let onBoardingNotificationSheetFactory: OnBoardingNotificationSheetFactory
    private let dictionaryMainViewFactory: DictionaryMainViewFactory
    private let appCoordinator: () -> AppCoordinatorProtocol

    public init(onBoardingNotificationSheetFactory: OnBoardingNotificationSheetFactory, dictionaryMainViewFactory: DictionaryMainViewFactory, appCoordinator: @escaping () -> AppCoordinatorProtocol) {
        self.onBoardingNotificationSheetFactory = onBoardingNotificationSheetFactory
        self.dictionaryMainViewFactory = dictionaryMainViewFactory
        self.appCoordinator = appCoordinator
    }

    public func make(selectedLevel: Int, selectedJobID: Int) -> BaseViewController {
        let viewController = OnBoardingNotificationViewController(onBoardingNotificationSheetFactory: onBoardingNotificationSheetFactory, dictionaryMainViewFactory: dictionaryMainViewFactory, appCoordinator: appCoordinator())
        viewController.isBottomTabbarHidden = true
        viewController.reactor = OnBoardingNotificationReactor(selectedLevel: selectedLevel, selectedJobID: selectedJobID)
        return viewController
    }
}
