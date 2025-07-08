import BaseFeature

public protocol BookmarkModalFactory {
    func make(onDismissWithMessage: @escaping (String) -> Void) -> BaseViewController
}
