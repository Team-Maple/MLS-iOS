import MLSBookmarkFeatureInterface
import MLSCore

public final class MockBookmarkModalFactory: BookmarkModalFactory {
    public init() {}

    public func make(bookmarkIds: [Int]) -> BaseViewController {
        let viewcontroller = BaseViewController()
        viewcontroller.view.backgroundColor = .redMLS
        return viewcontroller
    }

    public func make(bookmarkIds: [Int], onComplete: ((Bool) -> Void)? = nil) -> BaseViewController {
        let viewcontroller = BaseViewController()
        viewcontroller.view.backgroundColor = .redMLS
        return viewcontroller
    }
}
