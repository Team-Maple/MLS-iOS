import MLSCore

public protocol CollectionEditFactory {
    func make(bookmarks: [BookmarkResponse]) -> BaseViewController
}
