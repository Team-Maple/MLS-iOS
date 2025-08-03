import BaseFeature
import BookmarkFeatureInterface

public final class BookmarkOnBoardingFactoryImpl: BookmarkOnBoardingFactory {
    public init() {}

    public func make() -> BaseViewController {
        let reactor = BookmarkOnBoardingReactor()
        let viewController = BookmarkOnBoardingViewController()
        viewController.reactor = reactor
        return viewController
    }
}
