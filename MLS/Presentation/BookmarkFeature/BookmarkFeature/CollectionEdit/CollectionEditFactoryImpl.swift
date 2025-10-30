import BaseFeature
import BookmarkFeatureInterface
import DomainInterface

public final class CollectionEditFactoryImpl: CollectionEditFactory {
    private let setBookmarkUseCase: SetBookmarkUseCase
    private let bookmarkModalFactory: BookmarkModalFactory

    public init(setBookmarkUseCase: SetBookmarkUseCase, bookmarkModalFactory: BookmarkModalFactory) {
        self.setBookmarkUseCase = setBookmarkUseCase
        self.bookmarkModalFactory = bookmarkModalFactory
    }

    public func make() -> BaseViewController {
        let reactor = CollectionEditReactor()
        let viewController = CollectionEditViewController(bookmarkModalFactory: bookmarkModalFactory)
        viewController.reactor = reactor
        return viewController
    }
}
