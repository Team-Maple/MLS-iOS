import MLSCore
import MLSDictionaryFeatureInterface

public final class DictionarySearchFactoryImpl: DictionarySearchFactory {
    private let recentSearchRepository: RecentSearchRepository
    private let searchResultFactory: DictionarySearchResultFactory

    public init(recentSearchRepository: RecentSearchRepository, searchResultFactory: DictionarySearchResultFactory) {
        self.recentSearchRepository = recentSearchRepository
        self.searchResultFactory = searchResultFactory
    }

    public func make() -> BaseViewController {
        let reactor = DictionarySearchReactor(recentSearchRepository: recentSearchRepository)
        let viewController = DictionarySearchViewController(searchResultFactory: searchResultFactory)
        viewController.reactor = reactor
        return viewController
    }
}
