import DomainInterface
import Foundation

import RxSwift

public final class UserDefaultsRepositoryImpl: UserDefaultsRepository {
    private let key = "recentSearch"

    public init() { }

    public func fetchRecentSearch() -> Observable<[String]> {
        return Observable.create { observer in
            let current = UserDefaults.standard.stringArray(forKey: self.key) ?? []
            observer.onNext(current)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    public func addRecentSearch(keyword: String) -> Completable {
        return Completable.create { completable in
            var current = UserDefaults.standard.stringArray(forKey: self.key) ?? []
            
            // 중복 제거
            current.removeAll(where: { $0 == keyword})
            current.insert(keyword, at: 0)
            
            UserDefaults.standard.set(current, forKey: self.key)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    public func removeRecentSearch(keyword: String) -> Completable {
        return Completable.create { completable in
            var current = UserDefaults.standard.stringArray(forKey: self.key) ?? []

                // 해당 키워드 제거
                current.removeAll { $0 == keyword }

                // 다시 저장
                UserDefaults.standard.set(current, forKey: self.key)

                completable(.completed)
                return Disposables.create()
            }
    }
}
