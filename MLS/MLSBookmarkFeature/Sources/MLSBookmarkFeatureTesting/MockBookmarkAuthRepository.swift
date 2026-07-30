import MLSBookmarkFeatureInterface
import RxSwift

public final class MockBookmarkAuthRepository: BookmarkAuthRepository {
    public var isLoggedInResult: Observable<Bool> = .just(true)

    public init() {}

    public func isLoggedIn() -> Observable<Bool> {
        isLoggedInResult
    }
}
