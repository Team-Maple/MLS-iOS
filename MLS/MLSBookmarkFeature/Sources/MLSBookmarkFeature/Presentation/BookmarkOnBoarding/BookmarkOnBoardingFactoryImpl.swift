import MLSBookmarkFeatureInterface
import MLSCore

public final class BookmarkOnBoardingFactoryImpl: BookmarkOnBoardingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let reactor = BookmarkOnBoardingReactor()
        let viewController = BookmarkOnBoardingViewController()
        viewController.reactor = reactor
        return viewController
    }
}
