import AuthFeatureInterface
import BaseFeature

public struct OnBoardingNotificationFactoryImpl: OnBoadingNotificationFactory {
    private let onBoardingNotificationSheetFactory: OnBoardingNotificationSheetFactory

    public init(onBoardingNotificationSheetFactory: OnBoardingNotificationSheetFactory) {
        self.onBoardingNotificationSheetFactory = onBoardingNotificationSheetFactory
    }

    public func make(selectedLevel: Int, selectedJobID: Int) -> BaseViewController {
        let viewController = OnBoardingNotificationViewController(onBoardingNotificationSheetFactory: onBoardingNotificationSheetFactory)
        viewController.reactor = OnBoardingNotificationReactor(selectedLevel: selectedLevel, selectedJobID: selectedJobID)
        return viewController
    }
}
