import Foundation

import DomainInterface

import RxSwift

public class AuthAPIRepositoryImpl: AuthAPIRepository {
    private let provider: NetworkProvider
    private let tokenInterceptor: Interceptor
    private let authInterceptor: Interceptor

    public init(provider: NetworkProvider, tokenInterceptor: Interceptor, authInterceptor: Interceptor) {
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor
        self.authInterceptor = authInterceptor
    }

    public func fetchProfile() -> Observable<MyPageResponse?> {
        let endpoint = AuthEndPoint.fetchProfile()
        return provider.requestData(endPoint: endpoint, interceptor: tokenInterceptor)
            .map { $0.toMyPageDomain() }
    }

    public func loginWithKakao(credential: Credential) -> Observable<LoginResponse> {
        let endpoint = AuthEndPoint.loginWithKakao(credential: credential)
        return provider.requestData(endPoint: endpoint, interceptor: authInterceptor)
            .map { $0.toLoginDomain() }
            .catch { error in
                if case NetworkError.statusError(let code, _) = error, code == 404 {
                    return Observable.error(AuthError.userNotFound(credential: credential))
                } else {
                    return Observable.error(error)
                }
            }
    }

    public func loginWithApple(credential: Credential) -> Observable<LoginResponse> {
        let endpoint = AuthEndPoint.loginWithApple(credential: credential)
        return provider.requestData(endPoint: endpoint, interceptor: authInterceptor)
            .map { $0.toLoginDomain() }
            .catch { error in
                if case NetworkError.statusError(let code, _) = error, code == 404 {
                    return Observable.error(AuthError.userNotFound(credential: credential))
                } else {
                    return Observable.error(error)
                }
            }
    }

    public func signUpWithKakao(credential: Credential, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse> {
        let endpoint = AuthEndPoint.signupWithKakao(
            credential: credential.token,
            body: KakaoBody(
                providerId: credential.providerID,
                fcmToken: fcmToken,
                marketingAgreement: isMarketingAgreement
            )
        )
        return provider.requestData(endPoint: endpoint, interceptor: nil).map { $0.toSignUpDomain() }
    }

    public func signUpWithApple(credential: Credential, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse> {
        let endpoint = AuthEndPoint.signupWithApple(
            credential: credential.token,
            body: AppleBody(
                providerId: credential.providerID,
                fcmToken: fcmToken,
                marketingAgreement: isMarketingAgreement
            )
        )
        return provider.requestData(endPoint: endpoint, interceptor: nil).map { $0.toSignUpDomain() }
    }

    public func withdraw() -> Completable {
        let endPoint = AuthEndPoint.withdraw()
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
    }

    public func reissueToken(refreshToken: String) -> Observable<LoginResponse> {
        let endPoint = AuthEndPoint.reIssueToken(refreshToken: refreshToken)
        return provider.requestData(endPoint: endPoint, interceptor: nil).map { $0.toLoginDomain() }
    }

    public func fcmToken(fcmToken: String?) -> Completable {
        let endPoint = AuthEndPoint.fcmToken(body: FCMTokenBody(fcmToken: fcmToken))
        return provider.requestData(endPoint: endPoint, interceptor: authInterceptor)
    }

    public func fetchJobList() -> Observable<JobListResponse> {
        let endPoint = AuthEndPoint.fetchJobs()
        return provider.requestData(endPoint: endPoint, interceptor: nil).map { $0.toDomain() }
    }

    public func fetchJob(jobId: String) -> Observable<Job> {
        let endPoint = AuthEndPoint.fetchJob(jobId: jobId)
        return provider.requestData(endPoint: endPoint, interceptor: nil).map { $0.toDomain() }
    }

    public func updateUserInfo(level: Int, selectedJobID: Int) -> Completable {
        let endPoint = AuthEndPoint.updateCharacterInfo(body: UpdateInfoBody(level: level, jobId: selectedJobID))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
    }

    public func updateMarketingAgreement(credential: String, isMarketingAgreement: Bool) -> Completable {
        let endPoint = AuthEndPoint.updateMarketingAgreement(credential: credential, body: MarketingAgreementBody(marketingAgreement: isMarketingAgreement))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
    }

    public func updateNotificationAgreement(noticeAgreement: Bool, patchNoteAgreement: Bool, eventAgreement: Bool) -> Completable {
        let endPoint = AuthEndPoint.updateNotification(body: NotificationAgreementBody(noticeAgreement: noticeAgreement, patchNoteAgreement: patchNoteAgreement, eventAgreement: eventAgreement))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
    }

    public func updateNickName(nickName: String) -> Observable<MyPageResponse> {
        let endPoint = AuthEndPoint.updateNickName(body: NickNameBody(nickname: nickName))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toMyPageDomain() }
    }

    public func updateProfileImage(url: String) -> Completable {
        let endPoint = AuthEndPoint.updateProfileImage(body: UpdateProfileImageBody(profileImageUrl: url))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
    }
}

private extension AuthAPIRepositoryImpl {
    struct KakaoBody: Encodable {
        let provider = "KAKAO"
        let providerId: String
        let nickname: String? = nil
        let fcmToken: String?
        let marketingAgreement: Bool
    }

    struct AppleBody: Encodable {
        let provider = "APPLE"
        let providerId: String
        let nickname: String? = nil
        let fcmToken: String?
        let marketingAgreement: Bool
    }

    struct FCMTokenBody: Encodable {
        let fcmToken: String?
    }

    struct MarketingAgreementBody: Encodable {
        let marketingAgreement: Bool
    }

    struct NotificationAgreementBody: Encodable {
        let noticeAgreement: Bool
        let patchNoteAgreement: Bool
        let eventAgreement: Bool
    }

    struct NickNameBody: Encodable {
        let nickname: String
    }

    struct UpdateInfoBody: Encodable {
        let level: Int
        let jobId: Int
    }

    struct UpdateProfileImageBody: Encodable {
        let profileImageUrl: String
    }
}
