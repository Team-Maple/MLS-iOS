import BaseFeature
import DictionaryFeatureInterface
import DomainInterface


public final class DictionaryMainViewFactoryImpl: DictionaryMainViewFactory {
    private let dictionaryListFactory: DictionaryListFactory
    
    public init(dictionaryListFactory: DictionaryListFactory) {
        self.dictionaryListFactory = dictionaryListFactory
    }

    public func make() -> BaseViewController {
        let reactor = DictionaryMainReactor()
        let viewController = DictionaryMainViewController(reactor: reactor, dictionaryListFactory:  dictionaryListFactory)
        viewController.reactor = reactor
        return viewController
    }
}
