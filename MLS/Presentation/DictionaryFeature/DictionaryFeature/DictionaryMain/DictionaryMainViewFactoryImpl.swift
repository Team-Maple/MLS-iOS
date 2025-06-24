import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryMainViewFactoryImpl: DictionaryMainViewFactory {
    private let dictionaryMainListFactory: DictionaryMainListFactory
    private let searchFactory: DictionarySearchFactory

    public init(dictionaryMainListFactory: DictionaryMainListFactory, searchFactory: DictionarySearchFactory) {
        self.dictionaryMainListFactory = dictionaryMainListFactory
        self.searchFactory = searchFactory
    }

    public func make() -> BaseViewController {
        let reactor = DictionaryMainReactor()
        let viewController = DictionaryMainViewController(reactor: reactor, dictionaryMainListFactory: dictionaryMainListFactory, searchFactory: searchFactory)
        viewController.reactor = reactor
        return viewController
    }
}
