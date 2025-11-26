import BaseFeature
import DomainInterface

public protocol BookmarkModalFactory {
    func make(bookmarkIds: [Int]) -> BaseViewController
    func make(bookmarkIds: [Int], onComplete: ((Bool) -> Void)?) -> BaseViewController
}
