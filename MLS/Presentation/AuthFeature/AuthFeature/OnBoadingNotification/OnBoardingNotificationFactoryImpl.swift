import AuthFeatureInterface
import BaseFeature

public struct OnBoardingNotificationFactoryImpl: OnBoardingNotificationFactory {
    private let onBoardingNotificationSheetFactory: OnBoardingNotificationSheetFactory

    public init(onBoardingNotificationSheetFactory: OnBoardingNotificationSheetFactory) {
        self.onBoardingNotificationSheetFactory = onBoardingNotificationSheetFactory
    }

    public func make() -> BaseViewController {
        let viewController = OnBoardingNotificationViewController(onBoardingNotificationSheetFactory: onBoardingNotificationSheetFactory)
        viewController.reactor = OnBoardingNotificationReactor()
        return viewController
    }
}
