import MLSBookmarkFeatureInterface
import MLSCore

public final class BookmarkModalFactoryImpl: BookmarkModalFactory {
    private let addCollectionFactory: AddCollectionFactory
    private let collectionRepository: CollectionRepository

    public init(addCollectionFactory: AddCollectionFactory, collectionRepository: CollectionRepository) {
        self.addCollectionFactory = addCollectionFactory
        self.collectionRepository = collectionRepository
    }

    public func make(bookmarkIds: [Int]) -> BaseViewController {
        let reactor = BookmarkModalReactor(bookmarkIds: bookmarkIds, collectionRepository: collectionRepository)
        let viewController = BookmarkModalViewController(addCollectionFactory: addCollectionFactory)
        viewController.reactor = reactor
        return viewController
    }

    public func make(bookmarkIds: [Int], onComplete: ((Bool) -> Void)?) -> BaseViewController {
        let viewController = make(bookmarkIds: bookmarkIds)
        if let vc = viewController as? BookmarkModalViewController {
            vc.onCompleted = onComplete
        }
        return viewController
    }
}
