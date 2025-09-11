import BaseFeature
import MyPageFeatureInterface

public final class MyPageMainFactoryImpl: MyPageMainFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = MyPageMainViewController()
        viewController.reactor = MyPageMainReactor()
        return viewController
    }
}
