import Foundation

import RxSwift

public protocol AuthAPIRepository {
    func loginWithKakao(credential: Credential) -> Observable<LoginResponse>
    func loginWithApple(credential: Credential) -> Observable<LoginResponse>
    func signUpWithKakao(credential: Credential, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse>
    func signUpWithApple(credential: Credential, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse>
    func withdraw() -> Completable
    func fetchJobList() -> Observable<JobListResponse>
    func fetchJob(jobId: String) -> Observable<Job>
    func updateUserInfo(level: Int, selectedJobID: Int) -> Completable
    func reissueToken(refreshToken: String) -> Observable<LoginResponse>
    func fcmToken(fcmToken: String?) -> Completable
    func updateMarketingAgreement(credential: String, isMarketingAgreement: Bool) -> Completable
    func updateNotificationAgreement(noticeAgreement: Bool, patchNoteAgreement: Bool, eventAgreement: Bool) -> Completable
    func updateNickName(nickName: String) -> Observable<MyPageResponse>
    func updateProfileImage(url: String) -> Completable
    func fetchProfile() -> Observable<MyPageResponse?>
}
