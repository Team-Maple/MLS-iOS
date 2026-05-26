import MLSCore

public protocol DictionarySearchResultFactory {
    func make(keyword: String?) -> BaseViewController
}
