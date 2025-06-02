import UIKit

import AuthFeatureInterface
import BaseFeature
import Core

public struct OnBoardingNotificationFactoryImpl: OnBoardingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = OnBoardingNotificationViewController(factory: DIContainer.resolve(type: OnBoardingPresentableFactory.self))
        viewController.reactor = OnBoardingNotificationReactor()
        return viewController
    }
}
