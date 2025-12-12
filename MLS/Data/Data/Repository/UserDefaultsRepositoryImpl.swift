import Foundation

import DomainInterface

import RxSwift

public final class UserDefaultsRepositoryImpl: UserDefaultsRepository {
    private let recentSearchkey = "recentSearch"
    private let platformKey = "platformKey"
    private let bookmarkkey = "bookmark"
    private let dictionaryDetailkey = "dictionaryDetailkey"

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
        return Completable.create { completable in
            var current = UserDefaults.standard.stringArray(forKey: self.recentSearchkey) ?? []

            // 중복 제거
            current.removeAll(where: { $0 == keyword })
            current.insert(keyword, at: 0)

            UserDefaults.standard.set(current, forKey: self.recentSearchkey)
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

    public func fetchPlatform() -> Observable<LoginPlatform?> {
        return Observable.create { observer in
            if let rawValue = UserDefaults.standard.string(forKey: self.platformKey),
               let platform = LoginPlatform(rawValue: rawValue) {
                observer.onNext(platform)
            } else {
                observer.onNext(nil)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }

    public func savePlatform(platform: LoginPlatform) -> Completable {
        return Completable.create { completable in
            UserDefaults.standard.set(platform.rawValue, forKey: self.platformKey)
            completable(.completed)
            return Disposables.create()
        }
    }

    public func fetchBookmark() -> Observable<Bool> {
        return Observable.create { observer in
            let hasVisited = UserDefaults.standard.bool(forKey: self.bookmarkkey)
            observer.onNext(hasVisited)
            observer.onCompleted()
            return Disposables.create()
        }
    }

    public func saveBookmark() -> Completable {
        return Completable.create { completable in
            UserDefaults.standard.set(true, forKey: self.bookmarkkey)
            completable(.completed)
            return Disposables.create()
        }
    }

    public func fetchDictionaryDetail() -> Observable<Bool> {
        return Observable.create { observer in
            let hasVisited = UserDefaults.standard.bool(forKey: self.dictionaryDetailkey)
            observer.onNext(hasVisited)
            observer.onCompleted()
            return Disposables.create()
        }
    }

    public func saveDictionaryDetail() -> Completable {
        return Completable.create { completable in
            UserDefaults.standard.set(true, forKey: self.dictionaryDetailkey)
            completable(.completed)
            return Disposables.create()
        }
    }
}
