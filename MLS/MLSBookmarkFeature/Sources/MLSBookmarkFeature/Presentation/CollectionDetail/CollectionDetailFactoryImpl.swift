import RxSwift

import MLSBookmarkFeatureInterface
import MLSCore
import MLSDesignSystem
import MLSDictionaryFeatureInterface

public final class CollectionDetailFactoryImpl: CollectionDetailFactory {
    private let bookmarkModalFactory: BookmarkModalFactory
    private let collectionSettingFactory: CollectionSettingFactory
    private let addCollectionFactory: AddCollectionFactory
    private let collectionEditFactory: CollectionEditFactory
    private let dictionaryDetailFactory: DictionaryDetailFactory
    private let collectionRepository: CollectionRepository

    public init(
        bookmarkModalFactory: BookmarkModalFactory,
        collectionSettingFactory: CollectionSettingFactory,
        addCollectionFactory: AddCollectionFactory,
        collectionEditFactory: CollectionEditFactory,
        dictionaryDetailFactory: DictionaryDetailFactory,
        collectionRepository: CollectionRepository
    ) {
        self.bookmarkModalFactory = bookmarkModalFactory
        self.collectionSettingFactory = collectionSettingFactory
        self.addCollectionFactory = addCollectionFactory
        self.collectionEditFactory = collectionEditFactory
        self.dictionaryDetailFactory = dictionaryDetailFactory
        self.collectionRepository = collectionRepository
    }

    public func make(collection: CollectionResponse, onMoveToMain: (() -> Void)?) -> BaseViewController {
        let reactor = CollectionDetailReactor(
            collection: collection,
            collectionRepository: collectionRepository
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
