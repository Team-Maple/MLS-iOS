import BaseFeature
import BookmarkFeatureInterface

public final class BookmarkModalFactoryImpl: BookmarkModalFactory {
    public init() {}

    public func make(onDismissWithMessage: @escaping (String) -> Void) -> BaseViewController {
        let reactor = BookmarkModalReactor()
        let viewController = BookmarkModalViewController()
        viewController.reactor = reactor
        viewController.onDismissWithMessage = onDismissWithMessage
        return viewController
    }
}
