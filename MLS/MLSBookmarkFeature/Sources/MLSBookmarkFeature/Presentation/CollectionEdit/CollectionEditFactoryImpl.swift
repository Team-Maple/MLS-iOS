import MLSBookmarkFeatureInterface
import MLSCore

public final class CollectionEditFactoryImpl: CollectionEditFactory {
    private let bookmarkModalFactory: BookmarkModalFactory

    public init(bookmarkModalFactory: BookmarkModalFactory) {
        self.bookmarkModalFactory = bookmarkModalFactory
    }

    public func make(bookmarks: [BookmarkResponse]) -> BaseViewController {
        let reactor = CollectionEditReactor(bookmarks: bookmarks)
        let viewController = CollectionEditViewController(bookmarkModalFactory: bookmarkModalFactory)
        viewController.reactor = reactor
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
