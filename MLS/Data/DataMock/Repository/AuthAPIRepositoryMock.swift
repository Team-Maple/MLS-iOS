import Foundation

import DomainInterface

import RxSwift

public class AuthAPIRepositoryMock: AuthAPIRepository {
    
    private var tryCount: Int = 0

    public init() {}

    public func loginWithKakao(credential: Encodable) -> Observable<LoginResponse> {
        return Observable.just(.init(isRegister: false, accessToken: "testToken", refreshToken: "testToken"))
    }
    
    public func loginWithApple(credential: Encodable) -> Observable<LoginResponse> {
//        let error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "애플 로그인 실패"])
//        return Observable.error(error)
        return Observable.just(.init(isRegister: false, accessToken: "testToken", refreshToken: "testToken"))
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
        if tryCount == 0 {
            tryCount += 1
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
        if tryCount == 0 {
            tryCount += 1
            let error = NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "유저 정보 수정 실패"])
            return .error(error)
        } else {
            return .empty()
        }
    }
}
