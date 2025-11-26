import BaseFeature
import DomainInterface

public protocol BookmarkModalFactory {
    func make(bookmarkId: Int) -> BaseViewController
    func make(bookmarkId: Int, onComplete: ((Bool) -> Void)?) -> BaseViewController
}
