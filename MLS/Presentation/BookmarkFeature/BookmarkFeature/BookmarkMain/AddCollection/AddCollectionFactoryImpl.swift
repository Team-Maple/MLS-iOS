import BaseFeature
import BookmarkFeatureInterface

public final class AddCollectionFactoryImpl: AddCollectionFactory {
    public init() {}

    public func make(collection: BookmarkCollection?, onDismissWithMessage: @escaping (BookmarkCollection?) -> Void) -> BaseViewController {
        let viewController = AddCollectionViewController()
        viewController.reactor = AddCollectionModalReactor(collection: collection)
        viewController.onDismissWithMessage = onDismissWithMessage
        return viewController
    }
}
