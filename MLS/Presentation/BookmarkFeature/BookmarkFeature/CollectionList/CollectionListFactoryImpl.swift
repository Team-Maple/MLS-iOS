import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class CollectionListFactoryImpl: CollectionListFactory {
    private let fetchCollectionListUseCase: FetchCollectionListUseCase
    private let addCollectionFactory: AddCollectionFactory
    private let bookmarkDetailFactory: CollectionDetailFactory
    private let sortedBottomSheetFactory: SortedBottomSheetFactory

    public init(fetchCollectionListUseCase: FetchCollectionListUseCase, addCollectionFactory: AddCollectionFactory, bookmarkDetailFactory: CollectionDetailFactory, sortedBottomSheetFactory: SortedBottomSheetFactory) {
        self.fetchCollectionListUseCase = fetchCollectionListUseCase
        self.addCollectionFactory = addCollectionFactory
        self.bookmarkDetailFactory = bookmarkDetailFactory
        self.sortedBottomSheetFactory = sortedBottomSheetFactory
    }

    public func make() -> BaseViewController {
        let reactor = CollectionListReactor(fetchCollectionListUseCase: fetchCollectionListUseCase)
        let viewController = CollectionListViewController(addCollectionFactory: addCollectionFactory, detailFactory: bookmarkDetailFactory, sortedBottomSheetFactory: sortedBottomSheetFactory)
        viewController.reactor = reactor
        return viewController
    }
}
