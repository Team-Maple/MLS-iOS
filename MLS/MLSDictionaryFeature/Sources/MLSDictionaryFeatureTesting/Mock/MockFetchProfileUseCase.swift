import MLSMyPageFeatureInterface

import RxSwift

public final class MockFetchProfileUseCase: FetchProfileUseCase {
    public var result: Observable<MyPageResponse?> = .just(nil)

    public init() {}

    public func execute() -> Observable<MyPageResponse?> {
        result
    }
}
