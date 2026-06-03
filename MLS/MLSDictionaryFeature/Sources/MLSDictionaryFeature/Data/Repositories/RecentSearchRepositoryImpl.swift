import Foundation

import MLSDictionaryFeatureInterface

import RxSwift

public final class RecentSearchRepositoryImpl: RecentSearchRepository {
    private let recentSearchkey = "recentSearch"

    public init() {}

    public func fetchRecentSearch() -> Observable<[String]> {
        return Observable.create { observer in
            let current = UserDefaults.standard.stringArray(forKey: self.recentSearchkey) ?? []
            observer.onNext(current)
            observer.onCompleted()
            return Disposables.create()
        }
    }

    public func addRecentSearch(keyword: String) -> Completable {
        return Completable.create { [recentSearchkey] completable in
            let trimmedKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)

            guard !trimmedKeyword.isEmpty else {
                completable(.completed)
                return Disposables.create()
            }

            var current = UserDefaults.standard.stringArray(forKey: recentSearchkey) ?? []

            current.removeAll(where: { $0 == trimmedKeyword })
            current.insert(trimmedKeyword, at: 0)

            UserDefaults.standard.set(current, forKey: recentSearchkey)
            completable(.completed)
            return Disposables.create()
        }
    }

    public func removeRecentSearch(keyword: String) -> Completable {
        return Completable.create { completable in
            var current = UserDefaults.standard.stringArray(forKey: self.recentSearchkey) ?? []

            // 해당 키워드 제거
            current.removeAll { $0 == keyword }

            // 다시 저장
            UserDefaults.standard.set(current, forKey: self.recentSearchkey)

            completable(.completed)
            return Disposables.create()
        }
    }

    public func removeAllSearch() -> Completable {
        return Completable.create { completable in
            var current = UserDefaults.standard.stringArray(forKey: self.recentSearchkey) ?? []

            // 해당 키워드 제거
            current.removeAll()

            // 다시 저장
            UserDefaults.standard.set(current, forKey: self.recentSearchkey)

            completable(.completed)
            return Disposables.create()
        }
    }
}
