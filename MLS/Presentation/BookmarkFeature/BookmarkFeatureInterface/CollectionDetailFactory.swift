import BaseFeature

public protocol CollectionDetailFactory {
    func make(collection: BookmarkCollection) -> BaseViewController
}
