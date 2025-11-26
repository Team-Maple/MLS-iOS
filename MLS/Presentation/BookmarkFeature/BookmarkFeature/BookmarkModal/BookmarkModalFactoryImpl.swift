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

    public func make(bookmarkId: Int) -> BaseViewController {
        let reactor = BookmarkModalReactor(bookmarkId: bookmarkId, fetchCollectionListUseCase: fetchCollectionListUseCase, addCollectionsToBookmarkUseCase: addCollectionsToBookmarkUseCase)
        let viewController = BookmarkModalViewController(addCollectionFactory: addCollectionFactory)
        viewController.reactor = reactor
        return viewController
    }

    public func make(bookmarkId: Int, onComplete: ((Bool) -> Void)? = nil) -> BaseViewController {
        let viewController = make(bookmarkId: bookmarkId)
        if let viewController = viewController as? BookmarkModalViewController {
            viewController.onCompleted = onComplete
        }
        return viewController
    }
}
