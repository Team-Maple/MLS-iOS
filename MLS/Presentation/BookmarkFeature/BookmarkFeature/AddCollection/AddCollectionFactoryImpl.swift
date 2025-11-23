import BaseFeature
import BookmarkFeatureInterface
import DomainInterface

public final class AddCollectionFactoryImpl: AddCollectionFactory {
    public init() {}

    public func make(collection: CollectionResponse?, onDismissWithMessage: @escaping (CollectionResponse?) -> Void) -> BaseViewController {
        let viewController = AddCollectionViewController()
        viewController.reactor = AddCollectionModalReactor(collection: collection)
//        viewController.onDismissWithMessage = onDismissWithMessage
        return viewController
    }
}
