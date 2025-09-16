import BaseFeature
import MyPageFeatureInterface

public final class MyPageMainFactoryImpl: MyPageMainFactory {
    private let setProfileFactory: SetProfileFactory

    public init(setProfileFactory: SetProfileFactory) {
        self.setProfileFactory = setProfileFactory
    }

    public func make() -> BaseViewController {
        let viewController = MyPageMainViewController(setProfileFactory: setProfileFactory)
        viewController.reactor = MyPageMainReactor()
        return viewController
    }
}
