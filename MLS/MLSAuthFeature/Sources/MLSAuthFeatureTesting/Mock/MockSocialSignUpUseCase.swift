import MLSAuthFeatureInterface

import RxSwift

public final class MockSocialSignUpUseCase: SocialSignUpUseCase {
    private let result: Result<SignUpResponse, Error>

    public init(result: Result<SignUpResponse, Error> = .success(SignUpResponse(accessToken: "mock", refreshToken: "mock"))) {
        self.result = result
    }

    public func execute(credential: Credential, platform: LoginPlatform, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse> {
        switch result {
        case .success(let response): return .just(response)
        case .failure(let error): return .error(error)
        }
    }
}
