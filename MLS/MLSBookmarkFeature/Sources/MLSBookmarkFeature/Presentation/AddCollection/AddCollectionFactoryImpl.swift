import MLSBookmarkFeatureInterface
import MLSCore

public final class AddCollectionFactoryImpl: AddCollectionFactory {
    private let collectionRepository: CollectionRepository

    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }

    public func make(collection: CollectionResponse?) -> BaseViewController {
        let viewController = AddCollectionViewController()
        viewController.reactor = AddCollectionReactor(
            collection: collection,
            collectionRepository: collectionRepository
        )
        return viewController
    }
}
