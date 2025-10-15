import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryFactoryMock: DictionaryMainViewFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = BaseViewController()
        viewController.view.backgroundColor = .blue
        return viewController
    }
}
