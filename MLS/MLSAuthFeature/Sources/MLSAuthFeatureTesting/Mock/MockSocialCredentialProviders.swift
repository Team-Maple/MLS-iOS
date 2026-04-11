import MLSAuthFeatureInterface

import RxSwift

public final class MockKakaoCredentialProvider: SocialCredentialProvider {
    public init() {}

    public func getCredential() -> Observable<Credential> {
        return .just(Credential(token: "mock_kakao_token", providerID: "mock_kakao_provider_id"))
    }
}

public final class MockAppleCredentialProvider: SocialCredentialProvider {
    public init() {}

    public func getCredential() -> Observable<Credential> {
        return .just(Credential(token: "mock_apple_token", providerID: "mock_apple_provider_id"))
    }
}
