import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class CollectionDetailFactoryImpl: CollectionDetailFactory {
    private let bookmarkModalFactory: BookmarkModalFactory
    private let collectionSettingFactory: CollectionSettingFactory
    private let addCollectionFactory: AddCollectionFactory
    private let collectionEditFactory: CollectionEditFactory
    private let dictionaryDetailFactory: DictionaryDetailFactory

    private let setBookmarkUseCase: SetBookmarkUseCase
    private let fetchCollectionUseCase: FetchCollectionUseCase

    public init(
        bookmarkModalFactory: BookmarkModalFactory,
        collectionSettingFactory: CollectionSettingFactory,
        addCollectionFactory: AddCollectionFactory,
        collectionEditFactory: CollectionEditFactory,
        dictionaryDetailFactory: DictionaryDetailFactory,
        setBookmarkUseCase: SetBookmarkUseCase,
        fetchCollectionUseCase: FetchCollectionUseCase
    ) {
        self.bookmarkModalFactory = bookmarkModalFactory
        self.collectionSettingFactory = collectionSettingFactory
        self.addCollectionFactory = addCollectionFactory
        self.collectionEditFactory = collectionEditFactory
        self.dictionaryDetailFactory = dictionaryDetailFactory
        self.setBookmarkUseCase = setBookmarkUseCase
        self.fetchCollectionUseCase = fetchCollectionUseCase
    }

    public func make(collection: CollectionResponse) -> BaseViewController {
        let reactor = CollectionDetailReactor(
            setBookmarkUseCase: setBookmarkUseCase,
            fetchCollectionUseCase: fetchCollectionUseCase,
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
