import DomainInterface

import RxSwift

public final class DictionaryListAPIRepositoryImpl: DictionaryListAPIRepository {
    private let provider: NetworkProvider
    private let tokenInterceptor: Interceptor?

    public init(provider: NetworkProvider, tokenInterceptor: Interceptor? = nil) {
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor
    }
    // MARK: - 검색 카운트
    public func fetchSearchListCount(type: String, keyword: String?) -> Observable<SearchCountResponse> {
        let endPoint = DictionaryListEndPoint.fetchListCount(type: type, keyword: keyword)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map {$0.toDomain()}
    }
    // MARK: - 검색 리스트
    public func fetchSearchList(keyword: String?) -> Observable<DictionaryMainResponse> {
        let endPoint = DictionaryListEndPoint.fetchAllList(keyword: keyword)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map {$0.toDomain()}
    }
    // MARK: - 전체 리스트
    public func fetchAllList(keyword: String?, page: Int?) -> Observable<DictionaryMainResponse> {
        let endPoint = DictionaryListEndPoint.fetchAllList(keyword: keyword, page: page)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor).map {$0.toDomain()}
    }
    // MARK: - 몬스터 리스트
    public func fetchMonsterList(keyword: String?, minLevel: Int?, maxLevel: Int?, page: Int, size: Int, sort: String?) -> Observable<DictionaryMainResponse> {
        let endPoint = DictionaryListEndPoint.fetchMonsterList(keyword: keyword, minLevel: minLevel, maxLevel: maxLevel, page: page, size: size, sort: sort ?? "ASC")
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }
    // MARK: - NPC 리스트
    public func fetchNpcList(keyword: String, page: Int, size: Int, sort: String?) -> Observable<DictionaryMainResponse> {
        let endPoint = DictionaryListEndPoint.fetchNPCList(keyword: keyword, page: page, size: 20, sort: sort ?? "ASC")
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }
    // MARK: - Quest 리스트
    public func fetchQuestList(keyword: String, page: Int, size: Int, sort: String?) -> Observable<DictionaryMainResponse> {
        let endPoint = DictionaryListEndPoint.fetchQuestList(keyword: keyword, page: page, size: 20, sort: sort ?? "ASC")
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }
    // MARK: - Item 리스트
    public func fetchItemList(keyword: String?, jobId: [Int]?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, page: Int?, size: Int?, sort: String?) -> Observable<DictionaryMainResponse> {
        let endPoint = DictionaryListEndPoint.fetchItemList(keyword: keyword, jobId: jobId, minLevel: minLevel, maxLevel: maxLevel, categoryIds: categoryIds, page: page, size: size, sort: sort)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }
    // MARK: - Map 리스트
    public func fetchMapList(keyword: String, page: Int, size: Int, sort: String?) -> Observable<DictionaryMainResponse> {
        let endPoint = DictionaryListEndPoint.fetchMapList(keyword: keyword, page: page, size: 20, sort: sort ?? "ASC")
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }
}
