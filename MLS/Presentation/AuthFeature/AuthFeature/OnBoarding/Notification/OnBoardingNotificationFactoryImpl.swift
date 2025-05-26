import UIKit

import BaseFeature
import AuthFeatureInterface

public struct OnBoardingNotificationFactoryImpl: OnBoardingPresentableFactory {
    public init() {}

    public func make() -> UIViewController & ModalPresentable {
        let viewController = ModalViewController(modalStyle: .modal)
        viewController.reactor = ModalReactor()
        return viewController
    }
}
