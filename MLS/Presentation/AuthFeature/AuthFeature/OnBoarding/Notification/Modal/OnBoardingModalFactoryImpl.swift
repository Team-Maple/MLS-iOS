import UIKit

import AuthFeatureInterface
import BaseFeature
import Core

public struct OnBoardingModalFactoryImpl: OnBoardingPresentableFactory {
    public init() {}

    public func make() -> UIViewController & ModalPresentable {
        let viewController = OnBoardingModalViewController()
        viewController.reactor = OnBoardingModalReactor()
        return viewController
    }

}
