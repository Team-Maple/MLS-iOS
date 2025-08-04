import BaseFeature
import DictionaryFeatureInterface

public final class DictionarySearchResultFactoryImpl: DictionarySearchResultFactory {
    private let dictionaryMainListFactory: DictionaryMainListFactory
    public init(dictionaryMainListFactory: DictionaryMainListFactory) {
        self.dictionaryMainListFactory = dictionaryMainListFactory
    }

    public func make(keyword: String?) -> BaseViewController {
        let reactor = DictionarySearchResultReactor(keyword: keyword)
        let viewController = DictionarySearchResultViewController(dictionaryListFactory: dictionaryMainListFactory, reactor: reactor)
        return viewController
    }
}
