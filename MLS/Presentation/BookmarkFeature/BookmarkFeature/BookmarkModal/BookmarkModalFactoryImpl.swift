import BaseFeature
import BookmarkFeatureInterface

public final class BookmarkModalFactoryImpl: BookmarkModalFactory {
    private let addCollectionFactory: AddCollectionFactory
    
    public init(addCollectionFactory: AddCollectionFactory) {
        self.addCollectionFactory = addCollectionFactory
    }

    public func make(onDismissWithColletions: (([BookmarkCollection?]) -> Void)?, onDismissWithMessage: ((BookmarkCollection?) -> Void)?) -> BaseViewController {
        let reactor = BookmarkModalReactor()
        let viewController = BookmarkModalViewController(addCollectionFactory: addCollectionFactory)
        viewController.reactor = reactor
        viewController.onDismissWithMessage = onDismissWithMessage
        viewController.onDismissWithCollections = onDismissWithColletions
        return viewController
    }
}
