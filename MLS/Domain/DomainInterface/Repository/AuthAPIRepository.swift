import Foundation

import RxSwift

/// 사용자 인증 및 회원 관련 API 호출을 담당하는 레포지토리 프로토콜
public protocol AuthAPIRepository {

    /// 카카오 로그인 API 호출
    ///
    /// - Parameter credential: 카카오 로그인에 필요한 자격 증명 (예: access token 등)
    /// - Returns: 로그인 응답을 담은 Observable
    func loginWithKakao(credential: Credential) -> Observable<LoginResponse>

    /// 애플 로그인 API 호출
    ///
    /// - Parameter credential: 애플 로그인에 필요한 자격 증명 (예: identity token 등)
    /// - Returns: 로그인 응답을 담은 Observable
    func loginWithApple(credential: Credential) -> Observable<LoginResponse>

    /// 카카오 회원가입 API 호출
    ///
    /// - Parameters:
    ///   - credential: 회원가입에 필요한 사용자 정보
    ///   - isMarketingAgreement: 마케팅 수신 동의 여부
    /// - Returns: 회원가입 응답을 담은 Observable
    func signUpWithKakao(credential: Credential, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse>

    /// 애플 회원가입 API 호출
    ///
    /// - Parameters:
    ///   - credential: 회원가입에 필요한 사용자 정보
    ///   - isMarketingAgreement: 마케팅 수신 동의 여부
    /// - Returns: 회원가입 응답을 담은 Observable
    func signUpWithApple(credential: Credential, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse>

    func withdraw() -> Completable

    /// 직업 목록 조회 API 호출
    ///
    /// - Returns: 직업 목록 응답을 담은 Observable
    func fetchJobList() -> Observable<JobListResponse>

    func fetchJob(jobId: String) -> Observable<Job>

    /// 사용자 정보 수정 API 호출
    ///
    /// - Note: 레벨과 직업을 업데이트
    /// - Returns: 작업 완료 여부를 나타내는 Completable
    func updateUserInfo(level: Int, selectedJobID: Int) -> Completable

    /// 토큰 재발행 API 호출
    ///
    /// - Parameter credential: refreshToken
    /// - Returns: 토큰 갱신 응답을 담은 Observable
    func reissueToken(refreshToken: String) -> Observable<LoginResponse>

    func fcmToken(fcmToken: String?) -> Completable

    func updateMarketingAgreement(credential: String, isMarketingAgreement: Bool) -> Completable

    func updateNotificationAgreement(noticeAgreement: Bool, patchNoteAgreement: Bool, eventAgreement: Bool) -> Completable

    func updateNickName(nickName: String) -> Observable<MyPageResponse>

    func updateProfileImage(url: String) -> Completable

    func fetchProfile() -> Observable<MyPageResponse?>
}
