import BaseFeature
import DomainInterface

public protocol DictionaryMainListFactory {
    func make(type: DictionaryType, listType: DictionaryMainViewType, keyword: String?) -> BaseViewController
}
