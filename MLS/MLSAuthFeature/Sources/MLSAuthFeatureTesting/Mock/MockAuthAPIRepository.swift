import MLSAuthFeature
import RxSwift

public final class MockAuthAPIRepository: AuthAPIRepository {

    public init() {}

    public func loginWithKakao(credential: Credential) -> Observable<LoginResponse> {
        return .just(LoginResponse(isRegister: true, accessToken: "mock_access", refreshToken: "mock_refresh"))
    }

    public func loginWithApple(credential: Credential) -> Observable<LoginResponse> {
        return .just(LoginResponse(isRegister: true, accessToken: "mock_access", refreshToken: "mock_refresh"))
    }

    public func signUpWithKakao(credential: Credential, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse> {
        return .just(SignUpResponse(accessToken: "mock_access", refreshToken: "mock_refresh"))
    }

    public func signUpWithApple(credential: Credential, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse> {
        return .just(SignUpResponse(accessToken: "mock_access", refreshToken: "mock_refresh"))
    }

    public func withdraw() -> Completable { return .empty() }

    public func fetchJobList() -> Observable<JobListResponse> {
        return .just(JobListResponse(jobList: [
            Job(name: "전사", id: 1),
            Job(name: "마법사", id: 2),
            Job(name: "궁수", id: 3),
            Job(name: "도적", id: 4),
            Job(name: "해적", id: 5),
        ]))
    }

    public func fetchJob(jobId: String) -> Observable<Job> {
        return .just(Job(name: "전사", id: 1))
    }

    public func updateUserInfo(level: Int, selectedJobID: Int) -> Completable { return .empty() }

    public func reissueToken(refreshToken: String) -> Observable<LoginResponse> {
        return .just(LoginResponse(isRegister: true, accessToken: "mock_access", refreshToken: "mock_refresh"))
    }

    public func fcmToken(fcmToken: String?) -> Completable { return .empty() }

    public func updateMarketingAgreement(credential: String, isMarketingAgreement: Bool) -> Completable { return .empty() }

    public func updateNotificationAgreement(noticeAgreement: Bool, patchNoteAgreement: Bool, eventAgreement: Bool) -> Completable { return .empty() }

    public func updateNickName(nickName: String) -> Observable<MyPageResponse> {
        return .just(MyPageResponse(nickname: nickName, jobId: nil, jobName: "", level: nil, profileUrl: "", platform: .kakao, noticeAgreement: nil, patchNoteAgreement: nil, eventAgreement: nil))
    }

    public func updateProfileImage(url: String) -> Completable { return .empty() }

    public func fetchProfile() -> Observable<MyPageResponse?> { return .just(nil) }
}
