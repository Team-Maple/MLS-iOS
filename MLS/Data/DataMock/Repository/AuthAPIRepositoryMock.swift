import Foundation

import Data
import DomainInterface

import RxSwift

public class AuthAPIRepositoryMock: AuthAPIRepository {
    private var tryCount: Int = 0

    private let provider: NetworkProvider

    public init(provider: NetworkProvider) {
        self.provider = provider
    }

    public func loginWithKakao(credential: Credential) -> Observable<LoginResponse> {
        let endpoint: ResponsableEndPoint<APIResponseDTO<AuthResponseDTO>> = AuthEndPoint.loginWithKakao(credential: credential)

        return provider.requestData(endPoint: endpoint, interceptor: nil)
            .flatMap { resp in
                print("Success: \(resp.success), Message: \(resp.message ?? ""), Data: \(String(describing: resp.data))")

                if resp.success, let data = resp.data {
                    return Observable.just(data.toDomain())
                } else {
                    let msg = resp.message ?? "로그인 실패"
                    return .error(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: msg]))
                }
            }
    }

    public func loginWithApple(credential: Credential) -> Observable<LoginResponse> {
        let endpoint: ResponsableEndPoint<APIResponseDTO<AuthResponseDTO>> = AuthEndPoint.loginWithApple(credential: credential)

        return provider.requestData(endPoint: endpoint, interceptor: nil)
            .flatMap { resp in
                print("Success: \(resp.success), Message: \(resp.message ?? ""), Data: \(String(describing: resp.data))")

                if resp.success, let data = resp.data {
                    return Observable.just(data.toDomain())
                } else {
                    let msg = resp.message ?? "로그인 실패"
                    return .error(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: msg]))
                }
            }
    }

    public func signUpWithKakao(credential: Encodable, isMarketingAgreement: Bool) -> Observable<SignUpResponse> {
        return Observable.just(.init(accessToken: "testToken", refreshToken: "testToken"))
    }

    public func signUpWithApple(credential: Encodable, isMarketingAgreement: Bool) -> Observable<SignUpResponse> {
        if tryCount == 0 {
            tryCount += 1
            let error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "애플 로그인 실패"])
            return Observable.error(error)
        } else {
            return Observable.just(.init(accessToken: "testToken", refreshToken: "testToken"))
        }
    }

    public func fetchJobList() -> Observable<JobListResponse> {
        tryCount += 1
        if tryCount == 1 {
            let error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "직업 리스트 조회 실패"])
            return Observable.error(error)
        } else {
            return Observable.just(.init(jobList: [
                "마법사",
                "전사",
                "궁수",
                "도적",
                "해적"
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
}
