import BaseFeature
import BookmarkFeatureInterface
import DomainInterface

public final class BookmarkModalFactoryImpl: BookmarkModalFactory {
    private let addCollectionFactory: AddCollectionFactory
    private let fetchCollectionListUseCase: FetchCollectionListUseCase
    private let addCollectionAndBookmarkUseCase: AddCollectionAndBookmarkUseCase

    public init(addCollectionFactory: AddCollectionFactory, fetchCollectionListUseCase: FetchCollectionListUseCase, addCollectionAndBookmarkUseCase: AddCollectionAndBookmarkUseCase) {
        self.addCollectionFactory = addCollectionFactory
        self.fetchCollectionListUseCase = fetchCollectionListUseCase
        self.addCollectionAndBookmarkUseCase = addCollectionAndBookmarkUseCase
    }

    public func make(bookmarkIds: [Int]) -> BaseViewController {
        let reactor = BookmarkModalReactor(bookmarkIds: bookmarkIds, fetchCollectionListUseCase: fetchCollectionListUseCase, addCollectionAndBookmarkUseCase: addCollectionAndBookmarkUseCase)
        let viewController = BookmarkModalViewController(addCollectionFactory: addCollectionFactory)
        viewController.reactor = reactor
        return viewController
    }

    public func make(bookmarkIds: [Int], onComplete: ((Bool) -> Void)? = nil) -> BaseViewController {
        let viewController = make(bookmarkIds: bookmarkIds)
        if let viewController = viewController as? BookmarkModalViewController {
            viewController.onCompleted = onComplete
        }
        return viewController
    }
}
