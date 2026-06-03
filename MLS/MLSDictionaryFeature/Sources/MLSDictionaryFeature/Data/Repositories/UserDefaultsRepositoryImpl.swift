import Foundation

import MLSDictionaryFeatureInterface

import RxSwift

public final class UserDefaultsRepositoryImpl: UserDefaultsRepository {
    private let dictionaryDetailkey = "dictionaryDetailkey"

    public init() {}

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
