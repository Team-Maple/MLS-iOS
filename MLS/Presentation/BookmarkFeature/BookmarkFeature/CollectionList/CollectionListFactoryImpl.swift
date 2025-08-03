import BaseFeature
import BookmarkFeatureInterface

public final class CollectionListFactoryImpl: CollectionListFactory {
    private let addCollectionFactory: AddCollectionFactory
    private let bookmarkDetailFactory: CollectionDetailFactory

    public init(addCollectionFactory: AddCollectionFactory, bookmarkDetailFactory: CollectionDetailFactory) {
        self.addCollectionFactory = addCollectionFactory
        self.bookmarkDetailFactory = bookmarkDetailFactory
    }

    public func make() -> BaseViewController {
        let reactor = CollectionListReactor()
        let viewController = CollectionListViewController(addCollectionFactory: addCollectionFactory, detailFactory: bookmarkDetailFactory)
        viewController.reactor = reactor
        return viewController
    }
}
