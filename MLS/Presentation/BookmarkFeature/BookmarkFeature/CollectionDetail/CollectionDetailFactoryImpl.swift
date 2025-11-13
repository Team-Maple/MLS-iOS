import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class CollectionDetailFactoryImpl: CollectionDetailFactory {
    private let setBookmarkUseCase: SetBookmarkUseCase
    private let bookmarkModalFactory: BookmarkModalFactory
    private let collectionSettingFactory: CollectionSettingFactory
    private let addCollectionFactory: AddCollectionFactory
    private let collectionEditFactory: CollectionEditFactory
    private let dictionaryDetailFactory: DictionaryDetailFactory

    public init(
        setBookmarkUseCase: SetBookmarkUseCase,
        bookmarkModalFactory: BookmarkModalFactory,
        collectionSettingFactory: CollectionSettingFactory,
        addCollectionFactory: AddCollectionFactory,
        collectionEditFactory: CollectionEditFactory,
        dictionaryDetailFactory: DictionaryDetailFactory
    ) {
        self.setBookmarkUseCase = setBookmarkUseCase
        self.bookmarkModalFactory = bookmarkModalFactory
        self.collectionSettingFactory = collectionSettingFactory
        self.addCollectionFactory = addCollectionFactory
        self.collectionEditFactory = collectionEditFactory
        self.dictionaryDetailFactory = dictionaryDetailFactory
    }

    public func make(collection: BookmarkCollection) -> BaseViewController {
        let reactor = CollectionDetailReactor(
            setBookmarkUseCase: setBookmarkUseCase,
            collection: collection
        )
        let viewController = CollectionDetailViewController(
            reactor: reactor,
            bookmarkModalFactory: bookmarkModalFactory,
            collectionSettingFactory: collectionSettingFactory,
            addCollectionFactory: addCollectionFactory,
            collectionEditFactory: collectionEditFactory,
            dictionaryDetailFactory: dictionaryDetailFactory
        )
        return viewController
    }
}
