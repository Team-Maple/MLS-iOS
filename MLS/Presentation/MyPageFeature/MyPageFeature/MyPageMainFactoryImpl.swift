import BaseFeature
import MyPageFeatureInterface

public final class MyPageMainFactoryImpl: MyPageMainFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = MyPageViewController()
        return viewController
    }
}
