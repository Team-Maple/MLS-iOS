import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class CollectionDetailFactoryImpl: CollectionDetailFactory {
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase
    private let bookmarkModalFactory: BookmarkModalFactory
    private let collectionSettingFactory: CollectionSettingFactory
    private let addCollectionFactory: AddCollectionFactory
    private let collectionEditFactory: CollectionEditFactory

    public init(
        toggleBookmarkUseCase: ToggleBookmarkUseCase,
        bookmarkModalFactory: BookmarkModalFactory,
        collectionSettingFactory: CollectionSettingFactory,
        addCollectionFactory: AddCollectionFactory,
        collectionEditFactory: CollectionEditFactory
    ) {
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
        self.bookmarkModalFactory = bookmarkModalFactory
        self.collectionSettingFactory = collectionSettingFactory
        self.addCollectionFactory = addCollectionFactory
        self.collectionEditFactory = collectionEditFactory
    }

    public func make(collection: BookmarkCollection) -> BaseViewController {
        let reactor = CollectionDetailReactor(
            toggleBookmarkUseCase: toggleBookmarkUseCase,
            collection: collection
        )
        let viewController = CollectionDetailViewController(
            reactor: reactor,
            bookmarkModalFactory: bookmarkModalFactory,
            collectionSettingFactory: collectionSettingFactory,
            addCollectionFactory: addCollectionFactory,
            collectionEditFactory: collectionEditFactory
        )
        return viewController
    }
}
