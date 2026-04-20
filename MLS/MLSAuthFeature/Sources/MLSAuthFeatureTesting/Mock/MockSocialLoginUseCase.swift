import MLSAuthFeatureInterface

import RxSwift

public final class MockSocialLoginUseCase: SocialLoginUseCase {
    private let result: Result<LoginResponse, Error>

    public init(result: Result<LoginResponse, Error>) {
        self.result = result
    }

    public func execute(credential: Credential, platform: LoginPlatform) -> Observable<LoginResponse> {
        switch result {
        case .success(let response): return .just(response)
        case .failure(let error): return .error(error)
        }
    }
}
