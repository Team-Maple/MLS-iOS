import MLSCore

public protocol BookmarkListFactory {
    func make(type: DictionaryType, listType: DictionaryMainViewType) -> BaseViewController
}
