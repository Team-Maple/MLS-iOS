import BaseFeature

public protocol BookmarkDetailFactory {
    func make(collection: BookmarkCollection) -> BaseViewController
}
