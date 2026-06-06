import RxSwift

public protocol BookmarkUserDefaultsRepository {
    func hasVisitedOnboarding() -> Observable<Bool>
    func markOnboardingVisited() -> Completable
}
