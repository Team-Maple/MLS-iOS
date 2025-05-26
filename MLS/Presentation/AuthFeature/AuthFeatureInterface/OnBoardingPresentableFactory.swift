import UIKit

import BaseFeature

public protocol OnBoardingPresentableFactory {
    func make() -> UIViewController & ModalPresentable
}
