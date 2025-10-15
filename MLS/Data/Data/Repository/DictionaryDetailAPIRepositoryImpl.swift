import DomainInterface

import RxSwift

public final class DictionaryDetailAPIRepositoryImpl: DictionaryDetailAPIRepository {

    private let provider: NetworkProvider
    private let tokenInterceptor: Interceptor?

    public init(provider: NetworkProvider, tokenInterceptor: Interceptor?) {
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor
    }

    // MARK: - 몬스터 디테일 상세정보
    public func fetchMonsterDetail(id: Int) -> Observable<DictionaryDetailMonsterResponse> {
        let endPoint = DictionaryDetailEndPoint.fetchMonsterDetail(id: id)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0 }
    }

    public func fetchMonsterDetailDropItem(id: Int) -> Observable<[DictionaryDetailMonsterDropItemResponse]> {
        let endPoint = DictionaryDetailEndPoint.fetchMonsterDetailDropItem(id: id)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map {$0}
    }

    public func fetchMonsterDetailMap(id: Int) -> Observable<[DictionaryDetailMonsterMapResponse]> {
        let endPoint = DictionaryDetailEndPoint.fetchMonsterDetailMap(id: id)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0 }
    }
}
