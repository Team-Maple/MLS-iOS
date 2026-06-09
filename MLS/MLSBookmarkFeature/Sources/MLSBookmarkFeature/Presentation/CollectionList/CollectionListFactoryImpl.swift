import MLSBookmarkFeatureInterface
import MLSCore
import MLSDictionaryFeatureInterface

public final class CollectionListFactoryImpl: CollectionListFactory {
    private let collectionRepository: CollectionRepository
    private let addCollectionFactory: AddCollectionFactory
    private let collectionDetailFactory: CollectionDetailFactory
    private let sortedBottomSheetFactory: SortedBottomSheetFactory

    public init(
        collectionRepository: CollectionRepository,
        addCollectionFactory: AddCollectionFactory,
        collectionDetailFactory: CollectionDetailFactory,
        sortedBottomSheetFactory: SortedBottomSheetFactory
    ) {
        self.collectionRepository = collectionRepository
        self.addCollectionFactory = addCollectionFactory
        self.collectionDetailFactory = collectionDetailFactory
        self.sortedBottomSheetFactory = sortedBottomSheetFactory
    }

    public func make() -> BaseViewController {
        let reactor = CollectionListReactor(collectionRepository: collectionRepository)
        let viewController = CollectionListViewController(
            addCollectionFactory: addCollectionFactory,
            detailFactory: collectionDetailFactory,
            sortedBottomSheetFactory: sortedBottomSheetFactory
        )
        viewController.reactor = reactor
        return viewController
    }
}
