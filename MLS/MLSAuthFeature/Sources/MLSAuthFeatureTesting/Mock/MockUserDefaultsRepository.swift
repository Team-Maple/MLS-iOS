import MLSAuthFeatureInterface

import RxSwift

public final class MockUserDefaultsRepository: UserDefaultsRepository {
    private var platform: LoginPlatform?

    public init() {}

    public func fetchPlatform() -> Observable<LoginPlatform?> {
        return .just(platform)
    }

    public func savePlatform(platform: LoginPlatform) -> Completable {
        self.platform = platform
        return .empty()
    }

    public func deletePlatform() -> Completable {
        self.platform = nil
        return .empty()
    }
}
