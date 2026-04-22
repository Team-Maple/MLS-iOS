import AuthFeatureInterface
import BaseFeature

public final class MockLoginFactory: LoginFactory {
    public func make(exitRoute: LoginExitRoute, onLoginCompleted: (() -> Void)?) -> BaseViewController {
        let viewcontroller = BaseViewController()
        viewcontroller.view.backgroundColor = .redMLS
        return viewcontroller
    }
}
