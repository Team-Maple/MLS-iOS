import Foundation

import DomainInterface

import RxSwift

public class AuthAPIRepositoryImpl: AuthAPIRepository {
    private let provider: NetworkProvider
    private let tokenInterceptor: Interceptor

    public init(provider: NetworkProvider, interceptor: Interceptor) {
        self.provider = provider
        self.tokenInterceptor = interceptor
    }

    public func loginWithKakao(credential: Credential) -> Observable<LoginResponse> {
        let endpoint = AuthEndPoint.loginWithKakao(credential: credential)
        return provider.requestData(endPoint: endpoint, interceptor: nil)
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
        return provider.requestData(endPoint: endpoint, interceptor: nil)
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

    public func reissueToken(refreshToken: String) -> Observable<LoginResponse> {
        let endPoint = AuthEndPoint.reIssueToken(refreshToken: refreshToken)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0.toLoginDomain() }
    }

    public func fetchJobList() -> Observable<JobListResponse> {
        return Observable.just(.init(jobList: []))
    }

    public func updateUserInfo(level: Int, selectedJob: String) -> Completable {
        return .never()
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
}
