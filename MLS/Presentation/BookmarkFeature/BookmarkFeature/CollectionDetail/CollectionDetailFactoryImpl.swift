import BaseFeature
import BookmarkFeatureInterface
import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import RxSwift

public final class CollectionDetailFactoryImpl: CollectionDetailFactory {
    private let bookmarkModalFactory: BookmarkModalFactory
    private let collectionSettingFactory: CollectionSettingFactory
    private let addCollectionFactory: AddCollectionFactory
    private let collectionEditFactory: CollectionEditFactory
    private let dictionaryDetailFactory: DictionaryDetailFactory

    private let setBookmarkUseCase: SetBookmarkUseCase
    private let fetchCollectionUseCase: FetchCollectionUseCase
    private let deleteCollectionUseCase: DeleteCollectionUseCase
    private let addBookmarksToCollectionUseCase: AddBookmarksToCollectionUseCase

    public init(
        bookmarkModalFactory: BookmarkModalFactory,
        collectionSettingFactory: CollectionSettingFactory,
        addCollectionFactory: AddCollectionFactory,
        collectionEditFactory: CollectionEditFactory,
        dictionaryDetailFactory: DictionaryDetailFactory,
        setBookmarkUseCase: SetBookmarkUseCase,
        fetchCollectionUseCase: FetchCollectionUseCase,
        deleteCollectionUseCase: DeleteCollectionUseCase,
        addBookmarksToCollectionUseCase: AddBookmarksToCollectionUseCase
    ) {
        self.bookmarkModalFactory = bookmarkModalFactory
        self.collectionSettingFactory = collectionSettingFactory
        self.addCollectionFactory = addCollectionFactory
        self.collectionEditFactory = collectionEditFactory
        self.dictionaryDetailFactory = dictionaryDetailFactory
        self.setBookmarkUseCase = setBookmarkUseCase
        self.fetchCollectionUseCase = fetchCollectionUseCase
        self.deleteCollectionUseCase = deleteCollectionUseCase
        self.addBookmarksToCollectionUseCase = addBookmarksToCollectionUseCase
    }

    public func make(collection: CollectionResponse, onMoveToMain: (() -> Void)?) -> BaseViewController {
        let reactor = CollectionDetailReactor(
            collection: collection,
            setBookmarkUseCase: setBookmarkUseCase,
            fetchCollectionUseCase: fetchCollectionUseCase,
            deleteCollectionUseCase: deleteCollectionUseCase,
            addBookmarksToCollectionUseCase: addBookmarksToCollectionUseCase
        )

        let viewController = CollectionDetailViewController(
            reactor: reactor,
            bookmarkModalFactory: bookmarkModalFactory,
            collectionSettingFactory: collectionSettingFactory,
            addCollectionFactory: addCollectionFactory,
            collectionEditFactory: collectionEditFactory,
            dictionaryDetailFactory: dictionaryDetailFactory
        )

        reactor.pulse(\.$route)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak viewController] route in
                switch route {
                case .toMain:
                    onMoveToMain?()
                    viewController?.navigationController?.popToRootViewController(animated: true)
                default:
                    break
                }
            })
            .disposed(by: viewController.disposeBag)

        return viewController
    }
}
