@testable import MLSMyPageFeature

import Testing

import MLSAuthFeatureInterface
import MLSCore
import MLSMyPageFeatureInterface
import MLSMyPageFeatureTesting

import RxBlocking
import RxSwift

@Suite("MyPageRepositoryImplTests")
struct MyPageRepositoryImplTests {
    private let profileDTO = MemberDTO(
        id: "1",
        provider: "APPLE",
        nickname: "테스터",
        fcmToken: nil,
        marketingAgreement: true,
        noticeAgreement: true,
        patchNoteAgreement: false,
        eventAgreement: true,
        jobId: 1,
        level: 200,
        profileImageUrl: "https://example.com/profile.png"
    )

    private let updatedProfileDTO = MemberDTO(
        id: "2",
        provider: "KAKAO",
        nickname: "수정닉네임",
        fcmToken: nil,
        marketingAgreement: false,
        noticeAgreement: false,
        patchNoteAgreement: true,
        eventAgreement: false,
        jobId: 2,
        level: 210,
        profileImageUrl: "https://example.com/new.png"
    )

    private let jobDTO = JobsDTO(
        jobId: 3,
        jobName: "궁수",
        jobLevel: 10,
        parentJobId: nil,
    )

    @Test("profile 가져오기위해 provider 호출 및 domain 반환")
    func fetchProfile_returnsProfile() throws {
        let provider = MockNetworkProvider()
        provider.responseResult = profileDTO

        let sut = makeSUT(provider: provider)

        let result = try sut
            .fetchProfile()
            .toBlocking()
            .first()!

        #expect(provider.requestWithResponseCalled)
        #expect(result?.nickname == "테스터")
        #expect(result?.jobId == 1)
        #expect(result?.level == 200)
        #expect(result?.profileUrl == "https://example.com/profile.png")
        #expect(result?.platform == .apple)
    }

    // MARK: - fetchJob

    @Test("jobs 가져오기위해 interceptor 없이 호출 및 Job 반환")
    func fetchJob_returnsJob() throws {
        let provider = MockNetworkProvider()
        provider.responseResult = jobDTO

        let sut = makeSUT(provider: provider)

        let result = try sut
            .fetchJob(jobId: "3")
            .toBlocking()
            .first()

        #expect(provider.requestWithResponseCalled)
        #expect(result?.id == 3)
        #expect(result?.name == "궁수")
    }

    // MARK: - updateNickName

    @Test("nickName 업데이트하면 수정된 profile 반환")
    func updateNickName_returnsUpdatedProfile() throws {
        let provider = MockNetworkProvider()
        provider.responseResult = updatedProfileDTO

        let sut = makeSUT(provider: provider)

        let result = try sut
            .updateNickName(nickName: "수정닉네임")
            .toBlocking()
            .first()

        #expect(provider.requestWithResponseCalled)
        #expect(result?.nickname == "수정닉네임")
        #expect(result?.jobId == 2)
        #expect(result?.level == 210)
        #expect(result?.platform == .kakao)
    }

    // MARK: - updateProfileImage

    @Test("profileImage 업데이트 성공하면 complete")
    func updateProfileImage_returnsComplete() throws {
        let provider = MockNetworkProvider()
        provider.completableResult = .empty()

        let sut = makeSUT(provider: provider)

        _ = try sut
            .updateProfileImage(url: "https://example.com/image.png")
            .toBlocking()
            .first()

        #expect(provider.requestCompletableCalled)
    }

    @Test("profileImage 업데이트 실패하면 error 방출")
    func updateProfileImage_throwsError() {
        let provider = MockNetworkProvider()
        provider.completableResult = .error(NetworkError.httpError)

        let sut = makeSUT(provider: provider)

        #expect(throws: Error.self) {
            _ = try sut
                .updateProfileImage(url: "https://example.com/image.png")
                .toBlocking()
                .first()
        }

        #expect(provider.requestCompletableCalled)
    }
}

private extension MyPageRepositoryImplTests {
    func makeSUT(
        provider: MockNetworkProvider = MockNetworkProvider(),
        interceptor: MockInterceptor = MockInterceptor()
    ) -> MyPageRepositoryImpl {
        MyPageRepositoryImpl(
            provider: provider,
            interceptor: interceptor
        )
    }
}
