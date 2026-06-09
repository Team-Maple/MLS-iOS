import MLSCore
import MLSDictionaryFeatureInterface

public protocol BookmarkListFactory {
    func make(type: DictionaryType, listType: DictionaryMainViewType) -> BaseViewController
}
