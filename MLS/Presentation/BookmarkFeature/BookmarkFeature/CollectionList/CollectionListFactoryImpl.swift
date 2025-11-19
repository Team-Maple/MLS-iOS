import BaseFeature
import BookmarkFeatureInterface
import DomainInterface

public final class CollectionListFactoryImpl: CollectionListFactory {
    private let collectionListUseCase: FetchCollectionListUseCase
    private let createCollectionListUseCase: CreateCollectionListUseCase
    private let addCollectionFactory: AddCollectionFactory
    private let bookmarkDetailFactory: CollectionDetailFactory

    public init(collectionListUseCase: FetchCollectionListUseCase, createCollectionListUseCase: CreateCollectionListUseCase, addCollectionFactory: AddCollectionFactory, bookmarkDetailFactory: CollectionDetailFactory) {
        self.collectionListUseCase = collectionListUseCase
        self.createCollectionListUseCase = createCollectionListUseCase
        self.addCollectionFactory = addCollectionFactory
        self.bookmarkDetailFactory = bookmarkDetailFactory
    }

    public func make() -> BaseViewController {
        let reactor = CollectionListReactor(collectionListUseCase: collectionListUseCase, createCollectionListUseCase: createCollectionListUseCase)
        let viewController = CollectionListViewController(addCollectionFactory: addCollectionFactory, detailFactory: bookmarkDetailFactory)
        viewController.reactor = reactor
        return viewController
    }
}
