import Foundation

import MLSBookmarkFeatureInterface

import RxSwift

public final class BookmarkUserDefaultsRepositoryImpl: BookmarkUserDefaultsRepository {
    private let key = "bookmark_onboarding_visited"

    public init() {}

    public func hasVisitedOnboarding() -> Observable<Bool> {
        let hasVisited = UserDefaults.standard.bool(forKey: key)
        if !hasVisited {
            UserDefaults.standard.set(true, forKey: key)
            return .just(false)
        }
        return .just(true)
    }

    public func markOnboardingVisited() -> Completable {
        return Completable.create { [weak self] observer in
            guard let self else {
                observer(.completed)
                return Disposables.create()
            }
            UserDefaults.standard.set(true, forKey: self.key)
            observer(.completed)
            return Disposables.create()
        }
    }
}
