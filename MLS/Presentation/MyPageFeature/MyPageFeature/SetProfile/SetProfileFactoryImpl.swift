import BaseFeature
import MyPageFeatureInterface

public final class SetProfileFactoryImpl: SetProfileFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = SetProfileViewController()
        viewController.reactor = SetProfileReactor()
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
