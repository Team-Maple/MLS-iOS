import DomainInterface

import RxSwift

public final class DictionaryListAPIRepositoryImpl: DictionaryListAPIRepository {
    private let provider: NetworkProvider
    private let tokenInterceptor: Interceptor?
    
    public init(provider: NetworkProvider, tokenInterceptor: Interceptor? = nil) {
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor
    }
    // MARK: - 몬스터 리스트
    public func fetchMonsterList(keyword: String?, minLevel: Int?, maxLevel: Int?, page: Int, size: Int, sort: String?) -> Observable<DictionaryMainResponse> {
        let endPoint = DictionaryListEndPoint.fetchMonsterList(keyword: keyword, minLevel: minLevel ?? 1, maxLevel: maxLevel ?? 200, page: page, size: size, sort: sort ?? "ASC")
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
    public func fetchItemList(keyword: String?, jobId: Int?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, page: Int?, size: Int?, sort: String?) -> Observable<DictionaryMainResponse> {
        let endPoint = DictionaryListEndPoint.fetchItemList(keyword: keyword, jobId: jobId, minLevel: minLevel , maxLevel: maxLevel, categoryIds: categoryIds, page: page, size: size, sort: sort)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() } 
    }
    // MARK: - Map 리스트
    public func fetchMapList(keyword: String, page: Int, size: Int, sort: String?) -> Observable<DictionaryMainResponse> {
        let endPoint = DictionaryListEndPoint.fetchMapList(keyword: keyword, page: page, size: 20, sort: sort ?? "ASC")
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }
    
    // MARK: - Bookmark 추가
    public func postBookmark(bookmarkType: String, resourceId: Int) -> Observable<BookmarkResponse> {
        let endPoint = DictionaryListEndPoint.postBookmark(bookmarkType: bookmarkType, resourceId: resourceId)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain()}
    }
}
 
