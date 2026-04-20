import MLSAuthFeatureInterface

import RxSwift

/// FCM 토큰 등록만 실패하는 Mock. 나머지는 MockAuthAPIRepository에 위임.
public final class FCMFailingMockAuthAPIRepository: AuthAPIRepository {
    private let base = MockAuthAPIRepository()

    public init() {}

    public func loginWithKakao(credential: Credential) -> Observable<LoginResponse> { base.loginWithKakao(credential: credential) }
    public func loginWithApple(credential: Credential) -> Observable<LoginResponse> { base.loginWithApple(credential: credential) }
    public func signUpWithKakao(credential: Credential, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse> { base.signUpWithKakao(credential: credential, isMarketingAgreement: isMarketingAgreement, fcmToken: fcmToken) }
    public func signUpWithApple(credential: Credential, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse> { base.signUpWithApple(credential: credential, isMarketingAgreement: isMarketingAgreement, fcmToken: fcmToken) }
    public func withdraw() -> Completable { base.withdraw() }
    public func fetchJobList() -> Observable<JobListResponse> { base.fetchJobList() }
    public func updateUserInfo(level: Int, selectedJobID: Int) -> Completable { base.updateUserInfo(level: level, selectedJobID: selectedJobID) }
    public func reissueToken(refreshToken: String) -> Observable<LoginResponse> { base.reissueToken(refreshToken: refreshToken) }
    public func fcmToken(fcmToken: String?) -> Completable { .error(FCMError.failed) }
    public func updateNotificationAgreement(noticeAgreement: Bool, patchNoteAgreement: Bool, eventAgreement: Bool) -> Completable { base.updateNotificationAgreement(noticeAgreement: noticeAgreement, patchNoteAgreement: patchNoteAgreement, eventAgreement: eventAgreement) }

    private enum FCMError: Error { case failed }
}
