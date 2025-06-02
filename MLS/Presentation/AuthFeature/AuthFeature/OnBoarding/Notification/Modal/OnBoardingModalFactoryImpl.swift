import UIKit

import BaseFeature
import AuthFeatureInterface
import Core

public struct OnBoardingModalFactoryImpl: OnBoardingPresentableFactory {
    public init() {}
    
    public func make() -> UIViewController & ModalPresentable {
        let viewController = OnBoardingModalViewController(modalStyle: .modal)
        viewController.reactor = OnBoardingModalReactor()
        return viewController
    }
    
}
