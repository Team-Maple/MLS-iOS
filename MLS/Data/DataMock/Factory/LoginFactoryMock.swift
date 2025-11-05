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
}
