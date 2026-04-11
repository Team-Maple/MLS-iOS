import MLSAuthFeatureInterface

import RxSwift

public protocol UserDefaultsRepository {
    func fetchPlatform() -> Observable<LoginPlatform?>
    func savePlatform(platform: LoginPlatform) -> Completable
}
