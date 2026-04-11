import Testing

@testable import MLSAuthFeature
import MLSAuthFeatureInterface
import MLSAuthFeatureTesting

import RxBlocking
import RxSwift

@Suite("SocialLoginUseCase")
struct SocialLoginUseCaseTests {

    // MARK: - 플랫폼 저장

    @Test("Apple 로그인 성공: UserDefaults에 .apple 저장")
    func appleLogin_savesApplePlatform() throws {
        let userDefaultsRepo = MockUserDefaultsRepository()
        let sut = makeSUT(userDefaultsRepository: userDefaultsRepo)

        _ = try sut.execute(credential: .mock, platform: .apple).toBlocking().first()

        let saved = try userDefaultsRepo.fetchPlatform().toBlocking().first()
        #expect(saved == .apple)
    }

    @Test("Kakao 로그인 성공: UserDefaults에 .kakao 저장")
    func kakaoLogin_savesKakaoPlatform() throws {
        let userDefaultsRepo = MockUserDefaultsRepository()
        let sut = makeSUT(userDefaultsRepository: userDefaultsRepo)

        _ = try sut.execute(credential: .mock, platform: .kakao).toBlocking().first()

        let saved = try userDefaultsRepo.fetchPlatform().toBlocking().first()
        #expect(saved == .kakao)
    }

    // MARK: - 토큰 저장 실패

    @Test("토큰 저장 실패: 에러 전파")
    func tokenSaveFailure_propagatesError() {
        let sut = makeSUT(tokenRepository: FailingMockTokenRepository())

        #expect(throws: (any Error).self) {
            _ = try sut.execute(credential: .mock, platform: .apple).toBlocking().first()
        }
    }

    // MARK: - FCM 등록 실패

    @Test("FCM 등록 실패: 로그인 결과는 정상 반환")
    func fcmFailure_doesNotBlockLoginResult() throws {
        let tokenRepo = MockTokenRepository()
        _ = tokenRepo.saveToken(type: .fcmToken, value: "fcm_token")

        let sut = makeSUT(
            authRepository: FCMFailingMockAuthAPIRepository(),
            tokenRepository: tokenRepo
        )

        let result = try sut.execute(credential: .mock, platform: .apple).toBlocking().first()
        #expect(result != nil)
    }
}

// MARK: - Helpers

private func makeSUT(
    authRepository: AuthAPIRepository = MockAuthAPIRepository(),
    tokenRepository: TokenRepository = MockTokenRepository(),
    userDefaultsRepository: UserDefaultsRepository = MockUserDefaultsRepository()
) -> SocialLoginUseCaseImpl {
    SocialLoginUseCaseImpl(
        authRepository: authRepository,
        tokenRepository: tokenRepository,
        userDefaultsRepository: userDefaultsRepository
    )
}

