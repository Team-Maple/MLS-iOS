import BaseFeature
import BookmarkFeatureInterface

public final class CollectionListFactoryImpl: CollectionListFactory {
    private let addCollectionFactory: AddCollectionFactory
    private let bookmarkDetailFactory: BookmarkDetailFactory
    
    public init(addCollectionFactory: AddCollectionFactory, bookmarkDetailFactory: BookmarkDetailFactory) {
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
