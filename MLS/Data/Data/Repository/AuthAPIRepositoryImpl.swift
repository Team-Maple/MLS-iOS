import Foundation

import DomainInterface

import RxSwift

public class AuthAPIRepositoryImpl: AuthAPIRepository {
    private let provider: NetworkProvider

    public init(provider: NetworkProvider) {
        self.provider = provider
    }

    public func loginWithKakao(credential: Credential) -> Observable<LoginResponse> {
        let endpoint = AuthEndPoint.loginWithKakao(credential: credential)
        return provider.requestData(endPoint: endpoint, interceptor: nil).map { $0.toDomain() }
    }

    public func loginWithApple(credential: Credential) -> Observable<LoginResponse> {
        let endpoint = AuthEndPoint.loginWithApple(credential: credential)
        return provider.requestData(endPoint: endpoint, interceptor: nil).map { $0.toDomain() }
    }

    public func signUpWithKakao(credential: Encodable, isMarketingAgreement: Bool) -> Observable<SignUpResponse> {
        return Observable.just(.init(accessToken: "testToken", refreshToken: "testToken"))
    }

    public func signUpWithApple(credential: Encodable, isMarketingAgreement: Bool) -> Observable<SignUpResponse> {
        return Observable.just(.init(accessToken: "testToken", refreshToken: "testToken"))
    }

    public func fetchJobList() -> Observable<JobListResponse> {
        return Observable.just(.init(jobList: []))
    }

    public func updateUserInfo(level: Int, selectedJob: String) -> Completable {
        return .never()
    }
}
