import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionarySearchResultFactoryImpl: DictionarySearchResultFactory {
    private let dictionaryListCountUseCase: FetchDictionaryListCountUseCase
    private let dictionaryMainListFactory: DictionaryMainListFactory
    private let dictionarySearchListUseCase: FetchDictionarySearchListUseCase
    public init(dictionaryListCountUseCase: FetchDictionaryListCountUseCase, dictionaryMainListFactory: DictionaryMainListFactory, dictionarySearchListUseCase: FetchDictionarySearchListUseCase) {
        self.dictionaryListCountUseCase = dictionaryListCountUseCase
        self.dictionaryMainListFactory = dictionaryMainListFactory
        self.dictionarySearchListUseCase = dictionarySearchListUseCase
    }

    public func make(keyword: String?) -> BaseViewController {
        let reactor = DictionarySearchResultReactor(keyword: keyword, dictionarySearchUseCase: dictionarySearchListUseCase, dictionarySearchCountUseCase: dictionaryListCountUseCase)
        let viewController = DictionarySearchResultViewController(dictionaryListFactory: dictionaryMainListFactory, reactor: reactor)
        return viewController
    }
}
