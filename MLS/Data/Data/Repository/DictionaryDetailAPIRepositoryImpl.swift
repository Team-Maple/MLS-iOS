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
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0.toDomain() }
    }

    public func fetchMonsterDetailDropItem(id: Int, sort: String?) -> Observable<[DictionaryDetailMonsterDropItemResponse]> {
        let endPoint = DictionaryDetailEndPoint.fetchMonsterDetailDropItem(id: id, query: SortQuery(sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map {$0.map {$0.toDomain()}}
    }

    public func fetchMonsterDetailMap(id: Int) -> Observable<[DictionaryDetailMonsterMapResponse]> {
        let endPoint = DictionaryDetailEndPoint.fetchMonsterDetailMap(id: id)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0.map {$0.toDomain() }}
    }
    // MARK: - Npc 디테일 상세정보
    public func fetchNpcDetail(id: Int) -> Observable<DictionaryDetailNpcResponse> {
        let endPoint = DictionaryDetailEndPoint.fetchNpcDetail(id: id)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0.toDomain() }
    }

    public func fetchNpcDetailQuest(id: Int, sort: String?) -> Observable<[DictionaryDetailNpcQuestResponse]> {
        let endPoint = DictionaryDetailEndPoint.fetchNpcDetailQuest(id: id, query: SortQuery(sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0.map {$0.toDomain()} }

    }

    public func fetchNpcDetailMap(id: Int) -> Observable<[DictionaryDetailMonsterMapResponse]> {
        let endPoint = DictionaryDetailEndPoint.fetchNpcDetailMap(id: id)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0.map {$0.toDomain()} }
    }

    public func fetchItemDetail(id: Int) -> Observable<DictionaryDetailItemResponse> {
        let endPoint = DictionaryDetailEndPoint.fetchItemDetail(id: id)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0.toDomain() }
    }

    public func fetchItemDetailDropMonster(id: Int, sort: String?) -> Observable<[DictionaryDetailItemDropMonsterResponse]> {
        let endPoint = DictionaryDetailEndPoint.fetchItemDetailDropMonster(id: id, query: SortQuery(sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0.map {$0.toDomain() } }
    }

    public func fetchQuestDetail(id: Int) -> Observable<DictionaryDetailQuestResponse> {
        let endPoint = DictionaryDetailEndPoint.fetchQuestDetail(id: id)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0.toDomain() }
    }

    public func fetchQuestDetailLinkedQuestsDetail(id: Int) -> Observable<DictionaryDetailQuestLinkedQuestsResponse> {
        let endPoint = DictionaryDetailEndPoint.fetchQuestDetailLinkedQuests(id: id)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0.toDomain() }
    }

    public func fetchMapDetail(id: Int) -> Observable<DictionaryDetailMapResponse> {
        let endPoint = DictionaryDetailEndPoint.fetchMapDetail(id: id)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0.toDomain() }
    }

    public func fetchMapDetailSpawnMonster(id: Int, sort: String?) -> Observable<[DictionaryDetailMapSpawnMonsterResponse]> {
        let endPoint = DictionaryDetailEndPoint.fetchMapDetailSpawnMonster(id: id, query: SortQuery(sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map { $0.map {$0.toDomain()} }
    }

    public func fetchMapDetailNpc(id: Int) -> Observable<[DictionaryDetailMapNpcResponse]> {
        let endPoint = DictionaryDetailEndPoint.fetchMapDetailNpc(id: id)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map {$0.map {$0.toDomain()}}
    }
}

struct SortQuery: Encodable {
    let sort: String?
}
