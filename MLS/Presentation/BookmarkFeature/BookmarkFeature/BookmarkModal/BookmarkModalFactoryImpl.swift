import BaseFeature
import BookmarkFeatureInterface
import DomainInterface

public final class BookmarkModalFactoryImpl: BookmarkModalFactory {
    private let addCollectionFactory: AddCollectionFactory
    private let fetchCollectionListUseCase: FetchCollectionListUseCase
    private let addCollectionsToBookmarkUseCase: AddCollectionsToBookmarkUseCase

    public init(addCollectionFactory: AddCollectionFactory, fetchCollectionListUseCase: FetchCollectionListUseCase, addCollectionsToBookmarkUseCase: AddCollectionsToBookmarkUseCase) {
        self.addCollectionFactory = addCollectionFactory
        self.fetchCollectionListUseCase = fetchCollectionListUseCase
        self.addCollectionsToBookmarkUseCase = addCollectionsToBookmarkUseCase
    }

    public func make(bookmarkId: Int, onDismissWithColletions: (([CollectionResponse?]) -> Void)?, onDismissWithMessage: ((CollectionResponse?) -> Void)?) -> BaseViewController {
        let reactor = BookmarkModalReactor(bookmarkId: bookmarkId, fetchCollectionListUseCase: fetchCollectionListUseCase, addCollectionsToBookmarkUseCase: addCollectionsToBookmarkUseCase)
        let viewController = BookmarkModalViewController(addCollectionFactory: addCollectionFactory)
        viewController.reactor = reactor
        viewController.onDismissWithMessage = onDismissWithMessage
        viewController.onDismissWithCollections = onDismissWithColletions
        return viewController
    }
}
