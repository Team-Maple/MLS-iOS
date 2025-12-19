import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionarySearchResultFactoryImpl: DictionarySearchResultFactory {
    private let dictionaryListCountUseCase: FetchDictionaryListCountUseCase
    private let dictionaryMainListFactory: DictionaryMainListFactory
    private let dictionarySearchListUseCase: FetchDictionarySearchListUseCase
    private let recentSearchAddUseCase: RecentSearchAddUseCase

    public init(dictionaryListCountUseCase: FetchDictionaryListCountUseCase, dictionaryMainListFactory: DictionaryMainListFactory, dictionarySearchListUseCase: FetchDictionarySearchListUseCase, recentSearchAddUseCase: RecentSearchAddUseCase) {
        self.dictionaryListCountUseCase = dictionaryListCountUseCase
        self.dictionaryMainListFactory = dictionaryMainListFactory
        self.dictionarySearchListUseCase = dictionarySearchListUseCase
        self.recentSearchAddUseCase = recentSearchAddUseCase
    }

    public func make(keyword: String?) -> BaseViewController {
        let reactor = DictionarySearchResultReactor(keyword: keyword, dictionarySearchUseCase: dictionarySearchListUseCase, dictionarySearchCountUseCase: dictionaryListCountUseCase, recentSearchAddUseCase: recentSearchAddUseCase)
        let viewController = DictionarySearchResultViewController(dictionaryListFactory: dictionaryMainListFactory, reactor: reactor)
        return viewController
    }
}
