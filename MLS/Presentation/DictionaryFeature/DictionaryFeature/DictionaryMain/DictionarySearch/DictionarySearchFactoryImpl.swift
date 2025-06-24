import BaseFeature
import DictionaryFeatureInterface

public final class DictionarySearchFactoryImpl: DictionarySearchFactory {
    private let searchResultFactory: DictionarySearchResultFactory
    
    public init(searchResultFactory: DictionarySearchResultFactory) {
        self.searchResultFactory = searchResultFactory
    }

    public func make() -> BaseViewController {
        let reactor = DictionarySearchReactor()
        let viewController = DictionarySearchViewController(searchResultFactory: searchResultFactory)
        viewController.reactor = reactor
        return viewController
    }
}
