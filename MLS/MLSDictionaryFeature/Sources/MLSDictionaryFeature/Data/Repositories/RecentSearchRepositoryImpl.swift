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
        let keyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !keyword.isEmpty else {
            return .empty()
        }

        var current = UserDefaults.standard.stringArray(forKey: recentSearchkey) ?? []

        current.removeAll(where: { $0 == keyword })
        current.insert(keyword, at: 0)

        UserDefaults.standard.set(current, forKey: recentSearchkey)

        return .empty()
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
