import BaseFeature
import BookmarkFeatureInterface
import DomainInterface

public final class CollectionEditFactoryImpl: CollectionEditFactory {
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase
    private let bookmarkModalFactory: BookmarkModalFactory
    
    public init(toggleBookmarkUseCase: ToggleBookmarkUseCase, bookmarkModalFactory: BookmarkModalFactory) {
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
        self.bookmarkModalFactory = bookmarkModalFactory
    }

    public func make() -> BaseViewController {
        let reactor = CollectionEditReactor(toggleBookmarkUseCase: toggleBookmarkUseCase)
        let viewController = CollectionEditViewController(bookmarkModalFactory: bookmarkModalFactory)
        viewController.reactor = reactor
        return viewController
    }
}
