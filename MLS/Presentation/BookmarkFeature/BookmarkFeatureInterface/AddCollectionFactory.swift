import BaseFeature

public protocol AddCollectionFactory {
    func make(collection: BookmarkCollection?, onDismissWithMessage: @escaping (BookmarkCollection?) -> Void) -> BaseViewController
}
