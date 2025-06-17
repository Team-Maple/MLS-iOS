import BaseFeature
import DictionaryFeatureInterface

public final class DictionarySearchFactoryImpl: DictionarySearchFactory {
    public init() {}

    public func make() -> BaseViewController {
        let reactor = DictionarySearchReactor()
        let viewController = DictionarySearchViewController()
        viewController.reactor = reactor
        return viewController
    }
}
