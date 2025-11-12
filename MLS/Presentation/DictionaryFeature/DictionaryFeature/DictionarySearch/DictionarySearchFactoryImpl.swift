import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionarySearchFactoryImpl: DictionarySearchFactory {
    private let recentSearchRemoveUseCase: RecentSearchRemoveUseCase
    private let recentSearchAddUseCase: RecentSearchAddUseCase
    private let recentSearchFetchUseCase: RecentSearchFetchUseCase
    private let searchResultFactory: DictionarySearchResultFactory

    public init(recentSearchRemoveUseCase: RecentSearchRemoveUseCase, recentSearchAddUseCase: RecentSearchAddUseCase, searchResultFactory: DictionarySearchResultFactory, recentSearchFetchUseCase: RecentSearchFetchUseCase) {
        self.recentSearchRemoveUseCase = recentSearchRemoveUseCase
        self.recentSearchAddUseCase = recentSearchAddUseCase
        self.recentSearchFetchUseCase = recentSearchFetchUseCase
        self.searchResultFactory = searchResultFactory
    }

    public func make() -> BaseViewController {
        let reactor = DictionarySearchReactor(recentSearchAddUseCase: recentSearchAddUseCase, recentSearchRemoveUseCase: recentSearchRemoveUseCase, recentSearchFetchUseCase: recentSearchFetchUseCase)
        let viewController = DictionarySearchViewController(searchResultFactory: searchResultFactory)
        viewController.reactor = reactor
        return viewController
    }
}
