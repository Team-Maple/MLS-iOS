@testable import MLSMyPageFeature

import Testing

import MLSAuthFeatureInterface
import MLSAuthFeatureTesting
import MLSMyPageFeatureInterface
import MLSMyPageFeatureTesting

import RxBlocking
import RxSwift

@Suite("FetchProfileUseCaseTests")
struct FetchProfileUseCaseTests {
    @Test("job + jobName 모두 가져오기 성공")
    func profileWithJobId_returnsTrue() throws {
        let repo = MockMyPageRepository()

        repo.fetchProfileResult = .just(
            MyPageResponse.mock()
        )

        repo.fetchJobResult = .just(Job(name: "iOS 개발자", id: 1))

        let sut = FetchProfileUseCaseImpl(repository: repo)

        let result = try sut.execute().toBlocking().first()

        #expect(repo.fetchJobCalled == true)
        #expect(repo.receivedJobId == "1")
        #expect(result??.jobName == "iOS 개발자")
    }

    @Test("nil인 profile 가져오면 nil 반환")
    func nilProfile_returnsNil() throws {
        let repo = MockMyPageRepository()
        repo.fetchProfileResult = .just(nil)

        let sut = FetchProfileUseCaseImpl(repository: repo)

        let result = try sut.execute().toBlocking().first()

        #expect(result == .some(nil))
        #expect(repo.fetchJobCalled == false)
    }

    @Test("잘못된 jobId이면 jobName이 빈문자열")
    func noJobId_returnsFalse() throws {
        let repo = MockMyPageRepository()

        repo.fetchProfileResult = .just(
            MyPageResponse.mock()
        )

        let sut = FetchProfileUseCaseImpl(repository: repo)

        let result = try sut.execute().toBlocking().first()

        #expect(result??.jobName == "")
        #expect(repo.fetchJobCalled == true)
    }

    @Test("profile 가져오기 실패하면 error 전파")
    func profileError_returnsError() {
        let repo = MockMyPageRepository()

        enum DummyError: Error { case test }

        repo.fetchProfileResult = Observable<MyPageResponse?>.error(DummyError.test)

        let sut = FetchProfileUseCaseImpl(repository: repo)

        #expect(throws: DummyError.self) {
            _ = try sut.execute().toBlocking().first()
        }
    }
}

@Suite("LogoutUseCaseTests")
struct LogoutUseCaseTests {
    @Test("로그아웃 성공 시 모든 토큰 삭제")
    func logout_deletesAllTokens_returnsComplete() throws {
        let repo = MockTokenRepository()

        _ = repo.saveToken(type: .accessToken, value: "mock_access")
        _ = repo.saveToken(type: .refreshToken, value: "mock_refresh")
        _ = repo.saveToken(type: .fcmToken, value: "mock_fcm")

        let sut = LogoutUseCaseImpl(repository: repo)

        _ = try sut.execute().toBlocking().first()

        switch repo.fetchToken(type: .accessToken) {
            case .failure:
                #expect(true)
            case .success:
                #expect(Bool(false), "Expected failure")
        }

        switch repo.fetchToken(type: .refreshToken) {
            case .failure:
                #expect(true)
            case .success:
                #expect(Bool(false), "Expected failure")
        }

        switch repo.fetchToken(type: .fcmToken) {
            case .failure:
                #expect(true)
            case .success:
                #expect(Bool(false), "Expected failure")
        }
    }

    @Test("delete 실패 시 에러 전파")
    func deleteFailure_returnsError() {
        let repo = FailingMockTokenRepository()

        let sut = LogoutUseCaseImpl(repository: repo)

        #expect(throws: Error.self) {
            _ = try sut.execute().toBlocking().first()
        }
    }
}

@Suite("WithdrawUseCaseTests")
struct WithdrawUseCaseTests {
    @Test("회원탈퇴 성공")
    func withdraw_success() throws {
        let authRepo = MockAuthAPIRepository()
        let tokenRepo = MockTokenRepository()
        let userDefaultsRepo = MockUserDefaultsRepository()

        let sut = WithdrawUseCaseImpl(
            authRepository: authRepo,
            tokenRepository: tokenRepo,
            userDefaultsRepository: userDefaultsRepo
        )

        _ = try sut.execute().toBlocking().first()
    }

    @Test("성공 시 토큰 삭제")
    func withdraw_deleteTokens() throws {
        let authRepo = MockAuthAPIRepository()
        let tokenRepo = MockTokenRepository()
        let userDefaultsRepo = MockUserDefaultsRepository()

        _ = tokenRepo.saveToken(type: .accessToken, value: "access")
        _ = tokenRepo.saveToken(type: .refreshToken, value: "refresh")

        let sut = WithdrawUseCaseImpl(
            authRepository: authRepo,
            tokenRepository: tokenRepo,
            userDefaultsRepository: userDefaultsRepo
        )

        _ = try sut.execute().toBlocking().first()

        switch tokenRepo.fetchToken(type: .accessToken) {
            case .failure:
                #expect(true)
            case .success:
            #expect(Bool(false), "Expected failure")
        }

        switch tokenRepo.fetchToken(type: .refreshToken) {
            case .failure:
                #expect(true)
            case .success:
            #expect(Bool(false), "Expected failure")
        }
    }
}
