import BaseFeature
import DomainInterface

public protocol CollectionEditFactory {
    func make(bookmarks: [BookmarkResponse]) -> BaseViewController
}
