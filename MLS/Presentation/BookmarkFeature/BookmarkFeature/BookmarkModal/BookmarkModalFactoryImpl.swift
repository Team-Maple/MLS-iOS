import BaseFeature
import BookmarkFeatureInterface

public final class BookmarkModalFactoryImpl: BookmarkModalFactory {
    
    public init() {}

    public func make() -> BaseViewController {
        let reactor = BookmarkModalReactor()
        let viewController = BookmarkModalViewController()
        viewController.reactor = reactor
        return viewController
    }
}
