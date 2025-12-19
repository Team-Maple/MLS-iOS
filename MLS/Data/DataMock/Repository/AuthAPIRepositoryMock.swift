import Foundation

import Data
import DomainInterface

import RxSwift

public class AuthAPIRepositoryMock: AuthAPIRepository {
    public func fetchProfile() -> Observable<MyPageResponse?> {
        return .empty()
    }

    public func fetchJob(jobId: String) -> Observable<Job> {
        return .empty()
    }

    public func updateProfileImage(url: String) -> Completable {
        return .empty()
    }

    public func fetchProfile() -> Observable<MyPageResponse> {
        return .empty()
    }

    public func signUpWithKakao(credential: any DomainInterface.Credential, isMarketingAgreement: Bool, fcmToken: String?) -> RxSwift.Observable<DomainInterface.SignUpResponse> {
        if tryCount == 0 {
            tryCount += 1
            let error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "애플 로그인 실패"])
            return Observable.error(error)
        } else {
            return Observable.just(.init(accessToken: "testToken", refreshToken: "testToken"))
        }
    }

    public func signUpWithApple(credential: any DomainInterface.Credential, isMarketingAgreement: Bool, fcmToken: String?) -> RxSwift.Observable<DomainInterface.SignUpResponse> {
        return Observable.just(.init(accessToken: "testToken", refreshToken: "testToken"))
    }

    public func fcmToken(fcmToken: String?) -> Completable {
        return .empty()
    }

    private var tryCount: Int = 0

    private let provider: NetworkProvider

    public init(provider: NetworkProvider) {
        self.provider = provider
    }

    public func loginWithKakao(credential: Credential) -> Observable<LoginResponse> {
        return Observable.just(.init(isRegister: true, accessToken: "", refreshToken: ""))
    }

    public func loginWithApple(credential: Credential) -> Observable<LoginResponse> {
        return Observable.just(.init(isRegister: false, accessToken: "", refreshToken: ""))
    }

    public func reissueToken(refreshToken: String) -> Observable<LoginResponse> {
        return Observable.just(.init(isRegister: true, accessToken: "testToken", refreshToken: "testToken"))
    }

    public func withdraw() -> Completable {
        return .empty()
    }

    public func fetchJobList() -> Observable<JobListResponse> {
        tryCount += 1
        if tryCount == 1 {
            let error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "직업 리스트 조회 실패"])
            return Observable.error(error)
        } else {
            return Observable.just(.init(jobList: [
                Job(name: "마법사", id: 1)
            ]))
        }
    }

    public func updateUserInfo(level: Int, selectedJob: String) -> Completable {
        tryCount += 1
        if tryCount % 2 == 0 {
            let error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "유저 정보 수정 실패"])
            return .error(error)
        } else {
            return .empty()
        }
    }

    public func updateMarketingAgreement(credential: String, isMarketingAgreement: Bool) -> Completable {
        return .empty()
    }

    public func updateUserInfo(level: Int, selectedJobID: Int) -> Completable {
        return .empty()
    }

    public func updateNotificationAgreement(noticeAgreement: Bool, patchNoteAgreement: Bool, eventAgreement: Bool) -> Completable {
        return .empty()
    }

    public func updateNickName(nickName: String) -> Observable<MyPageResponse> {
        return .empty()
    }
}
