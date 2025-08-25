import BaseFeature

public protocol DictionarySearchResultFactory {
    func make(keyword: String?) -> BaseViewController
}
