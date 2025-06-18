import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryMainViewFactoryImpl: DictionaryMainViewFactory {
    private let dictionaryListFactory: DictionaryListFactory
    private let searchFactory: DictionarySearchFactory

    public init(dictionaryListFactory: DictionaryListFactory, searchFactory: DictionarySearchFactory) {
        self.dictionaryListFactory = dictionaryListFactory
        self.searchFactory = searchFactory
    }

    public func make() -> BaseViewController {
        let reactor = DictionaryMainReactor()
        let viewController = DictionaryMainViewController(reactor: reactor, dictionaryListFactory: dictionaryListFactory, searchFactory: searchFactory)
        viewController.reactor = reactor
        return viewController
    }
}
