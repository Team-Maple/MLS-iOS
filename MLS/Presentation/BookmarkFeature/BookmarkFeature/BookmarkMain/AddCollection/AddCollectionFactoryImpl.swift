import BaseFeature
import BookmarkFeatureInterface

public final class AddCollectionFactoryImpl: AddCollectionFactory {
    public init() {}

    public func make(onDismissWithMessage: @escaping (String) -> Void) -> BaseViewController {
        let viewController = AddCollectionViewController()
        viewController.reactor = AddCollectionModalReactor()
        viewController.onDismissWithMessage = onDismissWithMessage
        return viewController
    }
}
