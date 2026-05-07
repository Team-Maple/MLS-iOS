import MLSCore
import MLSMyPageFeatureInterface

public final class PolicyFactoryImpl: PolicyFactory {
    public init() {}

    public func make(type: PolicyType) -> BaseViewController {
        let viewController = PolicyViewController(type: type)
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
