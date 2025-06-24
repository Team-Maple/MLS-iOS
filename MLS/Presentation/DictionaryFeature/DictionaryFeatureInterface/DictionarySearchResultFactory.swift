import BaseFeature
import DomainInterface

public protocol DictionarySearchResultFactory {
    func make(keyword: String?) -> BaseViewController
}
