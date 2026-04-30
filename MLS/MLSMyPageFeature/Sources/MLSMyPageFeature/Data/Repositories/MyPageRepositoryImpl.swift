import MLSAuthFeatureInterface
import MLSCore
import MLSMyPageFeatureInterface

import RxSwift

public class MyPageRepositoryImpl: MyPageRepository {
    private let provider: NetworkProvider
    private let tokenInterceptor: Interceptor

    public init(provider: NetworkProvider, interceptor: Interceptor) {
        self.provider = provider
        self.tokenInterceptor = interceptor
    }
    
    public func fetchProfile() -> Observable<MyPageResponse?> {
        let endpoint = MyPageEndpoint.fetchProfile()
        return provider.requestData(endPoint: endpoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }
    
    public func fetchJob(jobId: String) -> Observable<Job> {
        let endPoint = MyPageEndpoint.fetchJob(jobId: jobId)
        return provider.requestData(endPoint: endPoint, interceptor: nil).map { $0.toDomain() }
    }

    
    public func updateNickName(nickName: String) -> Observable<MyPageResponse> {
        let endPoint = MyPageEndpoint.updateNickName(body: NickNameBody(nickname: nickName))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }
    
    public func updateProfileImage(url: String) -> Completable {
        let endPoint = MyPageEndpoint.updateProfileImage(body: UpdateProfileImageBody(profileImageUrl: url))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
    }
}

struct NickNameBody: Encodable {
    let nickname: String
}

struct UpdateProfileImageBody: Encodable {
    let profileImageUrl: String
}
