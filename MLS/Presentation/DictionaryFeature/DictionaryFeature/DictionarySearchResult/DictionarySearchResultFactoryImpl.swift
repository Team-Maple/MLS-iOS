import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionarySearchResultFactoryImpl: DictionarySearchResultFactory {
    private let dictionaryMainListFactory: DictionaryMainListFactory
    private let dictionarySearchListUseCase: FetchDictionarySearchListUseCase
    public init(dictionaryMainListFactory: DictionaryMainListFactory, dictionarySearchListUseCase: FetchDictionarySearchListUseCase) {
        self.dictionaryMainListFactory = dictionaryMainListFactory
        self.dictionarySearchListUseCase = dictionarySearchListUseCase
    }

    public func make(keyword: String?) -> BaseViewController {
        let reactor = DictionarySearchResultReactor(keyword: keyword, dictionarySearchUseCase: dictionarySearchListUseCase)
        let viewController = DictionarySearchResultViewController(dictionaryListFactory: dictionaryMainListFactory, reactor: reactor)
        return viewController
    }
}
