import Foundation

import DomainInterface

import RxSwift

public class AuthAPIRepositoryMock: AuthAPIRepository {
    public func loginWithKakao(credential: Encodable) -> Observable<LoginResponse> {
        return Observable.just(.init(isRegister: false, accessToken: "testToken", refreshToken: "testToken"))
    }
    
    public func loginWithApple(credential: Encodable) -> Observable<LoginResponse> {
        return Observable.just(.init(isRegister: true, accessToken: "testToken", refreshToken: "testToken"))
    }
    
    public func signUpWithKakao(credential: Encodable, isMarketingAgreement: Bool) -> Observable<SignUpResponse> {
        return Observable.just(.init(accessToken: "testToken", refreshToken: "testToken"))
    }
    
    public func signUpWithApple(credential: Encodable, isMarketingAgreement: Bool) -> Observable<SignUpResponse> {
        return Observable.just(.init(accessToken: "testToken", refreshToken: "testToken"))
    }
    
    public func fetchJobList() -> Observable<JobListResponse> {
        return Observable.just(.init(jobList: [
            "마법사",
            "전사",
            "궁수",
            "도적",
            "해적"
        ]))
    }
    
    public func updateUserInfo(level: Int, selectedJob: String) -> Completable {
        return .empty()
    }
}
