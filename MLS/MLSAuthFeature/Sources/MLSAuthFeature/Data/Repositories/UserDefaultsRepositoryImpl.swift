import Foundation

import MLSAuthFeatureInterface

import RxSwift

public final class UserDefaultsRepositoryImpl: UserDefaultsRepository {
    private let platformKey = "platformKey"

    public init() {}

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
}
