import MLSBookmarkFeatureInterface
import RxSwift

public final class MockBookmarkUserDefaultsRepository: BookmarkUserDefaultsRepository {
    public var hasVisitedResult: Observable<Bool> = .just(false)
    public var markVisitedResult: Completable = .empty()

    public init() {}

    public func hasVisitedOnboarding() -> Observable<Bool> {
        hasVisitedResult
    }

    public func markOnboardingVisited() -> Completable {
        markVisitedResult
    }
}
