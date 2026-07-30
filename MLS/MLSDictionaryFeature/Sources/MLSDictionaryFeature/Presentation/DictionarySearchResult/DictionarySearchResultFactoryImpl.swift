import MLSCore
import MLSDictionaryFeatureInterface

public final class DictionarySearchResultFactoryImpl: DictionarySearchResultFactory {
    private let dictionaryListAPIRepository: DictionaryListAPIRepository
    private let recentSearchRepository: RecentSearchRepository
    private let dictionaryMainListFactory: DictionaryMainListFactory

    public init(dictionaryListAPIRepository: DictionaryListAPIRepository, recentSearchRepository: RecentSearchRepository, dictionaryMainListFactory: DictionaryMainListFactory) {
        self.dictionaryListAPIRepository = dictionaryListAPIRepository
        self.recentSearchRepository = recentSearchRepository
        self.dictionaryMainListFactory = dictionaryMainListFactory
    }

    public func make(keyword: String?) -> BaseViewController {
        let reactor = DictionarySearchResultReactor(keyword: keyword, dictionaryListAPIRepository: dictionaryListAPIRepository, recentSearchRepository: recentSearchRepository)
        let viewController = DictionarySearchResultViewController(dictionaryListFactory: dictionaryMainListFactory, reactor: reactor)
        return viewController
    }
}
