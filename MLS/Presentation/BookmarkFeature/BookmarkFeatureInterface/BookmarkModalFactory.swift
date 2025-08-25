import BaseFeature

public protocol BookmarkModalFactory {
    func make(onDismissWithColletions: (([BookmarkCollection?]) -> Void)?, onDismissWithMessage: ((BookmarkCollection?) -> Void)?) -> BaseViewController
}
