import AuthFeatureInterface
import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class LoginFactoryMock: LoginFactory {
    public init() {}

    public func make(exitRoute: LoginExitRoute) -> BaseViewController {
        let viewController = BaseViewController()
        viewController.view.backgroundColor = .blue
        return viewController
    }

    public func make(exitRoute: LoginExitRoute, onLoginCompleted: (() -> Void)?) -> BaseViewController {
        return BaseViewController()
    }

}
