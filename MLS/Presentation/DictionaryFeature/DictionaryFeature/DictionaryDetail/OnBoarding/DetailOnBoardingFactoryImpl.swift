import BaseFeature
import DictionaryFeatureInterface

public final class DetailOnBoardingFactoryImpl: DetailOnBoardingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let reactor = DetailOnBoardingReactor()
        let viewController = DetailOnBoardingViewController()
        viewController.reactor = reactor
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
