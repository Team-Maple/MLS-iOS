import BaseFeature

public protocol BookmarkModalFactory {
    func make(onDismissWithMessage: @escaping (BookmarkCollection?) -> Void) -> BaseViewController
}
