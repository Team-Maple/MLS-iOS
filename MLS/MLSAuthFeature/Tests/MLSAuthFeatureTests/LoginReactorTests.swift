import Testing

@testable import MLSAuthFeature
import MLSAuthFeatureInterface
import MLSAuthFeatureTesting

import RxBlocking
import RxSwift

@Suite("LoginReactor - 로그인 라우팅")
struct LoginReactorTests {

    // MARK: - Apple 로그인

    @Test("Apple 로그인 + isRegister true: 홈으로 이동")
    func appleLogin_registeredUser_navigatesToHome() throws {
        let reactor = makeSUT(response: .registered)
        let mutation = try reactor.mutate(action: .appleLoginButtonTapped).toBlocking().first()!
        let state = reactor.reduce(state: reactor.initialState, mutation: mutation)

        if case .home = state.route {} else {
            Issue.record("Expected .home, got \(state.route)")
        }
    }

    @Test("Apple 로그인 + isRegister false: 약관 동의 화면으로 이동")
    func appleLogin_unregisteredUser_navigatesToTerms() throws {
        let reactor = makeSUT(response: .unregistered)
        let mutation = try reactor.mutate(action: .appleLoginButtonTapped).toBlocking().first()!
        let state = reactor.reduce(state: reactor.initialState, mutation: mutation)

        if case .termsAgreements = state.route {} else {
            Issue.record("Expected .termsAgreements, got \(state.route)")
        }
    }

    // MARK: - Kakao 로그인

    @Test("Kakao 로그인 + isRegister false: 약관 동의 화면으로 이동")
    func kakaoLogin_unregisteredUser_navigatesToTerms() throws {
        let reactor = makeSUT(response: .unregistered)
        let mutation = try reactor.mutate(action: .kakaoLoginButtonTapped).toBlocking().first()!
        let state = reactor.reduce(state: reactor.initialState, mutation: mutation)

        if case .termsAgreements = state.route {} else {
            Issue.record("Expected .termsAgreements, got \(state.route)")
        }
    }

    // MARK: - 에러 라우팅

    @Test("userNotFound 에러: 약관 동의 화면으로 이동")
    func userNotFound_navigatesToTerms() throws {
        let reactor = makeSUT(error: AuthError.userNotFound(credential: Credential(token: "", providerID: "")))
        let mutation = try reactor.mutate(action: .appleLoginButtonTapped).toBlocking().first()!
        let state = reactor.reduce(state: reactor.initialState, mutation: mutation)

        if case .termsAgreements = state.route {} else {
            Issue.record("Expected .termsAgreements on userNotFound, got \(state.route)")
        }
    }

    @Test("그 외 에러: 에러 화면으로 이동")
    func otherError_navigatesToError() throws {
        let reactor = makeSUT(error: AuthError.tokenExpired)
        let mutation = try reactor.mutate(action: .appleLoginButtonTapped).toBlocking().first()!
        let state = reactor.reduce(state: reactor.initialState, mutation: mutation)

        if case .error = state.route {} else {
            Issue.record("Expected .error, got \(state.route)")
        }
    }

    // MARK: - 기타 액션

    @Test("게스트 로그인: 홈으로 이동")
    func guestLogin_navigatesToHome() throws {
        let reactor = makeSUT()
        let mutation = try reactor.mutate(action: .guestLoginButtonTapped).toBlocking().first()!
        let state = reactor.reduce(state: reactor.initialState, mutation: mutation)

        if case .home = state.route {} else {
            Issue.record("Expected .home, got \(state.route)")
        }
    }

    @Test("뒤로가기: dismiss")
    func backButton_navigatesToDismiss() throws {
        let reactor = makeSUT()
        let mutation = try reactor.mutate(action: .backButtonTapped).toBlocking().first()!
        let state = reactor.reduce(state: reactor.initialState, mutation: mutation)

        if case .dismiss = state.route {} else {
            Issue.record("Expected .dismiss, got \(state.route)")
        }
    }
}

// MARK: - Helpers

private func makeSUT(
    response: LoginResponse = .registered
) -> LoginReactor {
    LoginReactor(
        appleProvider: MockAppleCredentialProvider(),
        kakaoProvider: MockKakaoCredentialProvider(),
        socialLoginUseCase: MockSocialLoginUseCase(result: .success(response)),
        userDefaultsRepository: MockUserDefaultsRepository()
    )
}

private func makeSUT(error: Error) -> LoginReactor {
    LoginReactor(
        appleProvider: MockAppleCredentialProvider(),
        kakaoProvider: MockKakaoCredentialProvider(),
        socialLoginUseCase: MockSocialLoginUseCase(result: .failure(error)),
        userDefaultsRepository: MockUserDefaultsRepository()
    )
}
