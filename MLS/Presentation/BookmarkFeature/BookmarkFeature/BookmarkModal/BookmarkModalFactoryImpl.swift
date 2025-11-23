import BaseFeature
import BookmarkFeatureInterface
import DomainInterface

public final class BookmarkModalFactoryImpl: BookmarkModalFactory {
    private let addCollectionFactory: AddCollectionFactory

    public init(addCollectionFactory: AddCollectionFactory) {
        self.addCollectionFactory = addCollectionFactory
    }

    public func make(onDismissWithColletions: (([CollectionResponse?]) -> Void)?, onDismissWithMessage: ((CollectionResponse?) -> Void)?) -> BaseViewController {
        let reactor = BookmarkModalReactor()
        let viewController = BookmarkModalViewController(addCollectionFactory: addCollectionFactory)
        viewController.reactor = reactor
        viewController.onDismissWithMessage = onDismissWithMessage
        viewController.onDismissWithCollections = onDismissWithColletions
        return viewController
    }
}
