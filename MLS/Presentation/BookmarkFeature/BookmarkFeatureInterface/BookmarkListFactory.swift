import BaseFeature
import DomainInterface

public protocol BookmarkListFactory {
    func make(type: DictionaryType, listType: DictionaryMainViewType) -> BaseViewController
}
