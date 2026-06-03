import MLSCore

/// Bookmark 모듈 분리 후 제거
public protocol BookmarkModalFactory {
    func make(bookmarkIds: [Int]) -> BaseViewController
    func make(bookmarkIds: [Int], onComplete: ((Bool) -> Void)?) -> BaseViewController
}
