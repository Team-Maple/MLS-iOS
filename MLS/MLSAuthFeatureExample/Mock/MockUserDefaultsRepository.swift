import MLSAuthFeature
import RxSwift

final class MockUserDefaultsRepository: UserDefaultsRepository {
    private var platform: LoginPlatform?

    func fetchPlatform() -> Observable<LoginPlatform?> {
        return .just(platform)
    }

    func savePlatform(platform: LoginPlatform) -> Completable {
        self.platform = platform
        return .empty()
    }
}
