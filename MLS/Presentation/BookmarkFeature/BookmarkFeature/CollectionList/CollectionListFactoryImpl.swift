import BaseFeature
import BookmarkFeatureInterface
import DomainInterface

public final class CollectionListFactoryImpl: CollectionListFactory {
    private let fetchCollectionListUseCase: FetchCollectionListUseCase
    private let addCollectionFactory: AddCollectionFactory
    private let bookmarkDetailFactory: CollectionDetailFactory

    public init(fetchCollectionListUseCase: FetchCollectionListUseCase, addCollectionFactory: AddCollectionFactory, bookmarkDetailFactory: CollectionDetailFactory) {
        self.fetchCollectionListUseCase = fetchCollectionListUseCase
        self.addCollectionFactory = addCollectionFactory
        self.bookmarkDetailFactory = bookmarkDetailFactory
    }

    public func make() -> BaseViewController {
        let reactor = CollectionListReactor(fetchCollectionListUseCase: fetchCollectionListUseCase)
        let viewController = CollectionListViewController(addCollectionFactory: addCollectionFactory, detailFactory: bookmarkDetailFactory)
        viewController.reactor = reactor
        return viewController
    }
}
