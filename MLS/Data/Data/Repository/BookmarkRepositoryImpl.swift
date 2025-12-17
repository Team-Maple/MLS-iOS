import Foundation

import DomainInterface

import RxSwift

public class BookmarkRepositoryImpl: BookmarkRepository {
    private let provider: NetworkProvider
    private let tokenInterceptor: Interceptor

    public init(provider: NetworkProvider, interceptor: Interceptor) {
        self.provider = provider
        self.tokenInterceptor = interceptor
    }

    public func setBookmark(bookmarkId: Int, type: DictionaryItemType) -> Observable<Int> {
        let endPoint = BookmarkEndPoint.setBookmark(body: SetBookmarkQuery(bookmarkType: type.rawValue, resourceId: bookmarkId))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }

    public func deleteBookmark(bookmarkId: Int) -> Observable<Int?> {
        let endPoint = BookmarkEndPoint.deleteBookmark(bookmarkId: bookmarkId)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toBookmarkDomain() }
    }

    public func fetchBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        let endPoint = BookmarkEndPoint.fetchBookmark(query: SortedQuery(sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }

    public func fetchMonsterBookmark(minLevel: Int?, maxLevel: Int?, sort: String?) -> Observable<[BookmarkResponse]> {
        let endPoint = BookmarkEndPoint.fetchMonsterBookmark(query: BookmarkMonsterQuery(minLevel: minLevel, maxLevel: maxLevel, sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }

    public func fetchNPCBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        let endPoint = BookmarkEndPoint.fetchNPCBookmark(query: SortedQuery(sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }

    public func fetchQuestBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        let endPoint = BookmarkEndPoint.fetchQuestBookmark(query: SortedQuery(sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }

    public func fetchItemBookmark(jobId: Int?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, sort: String?) -> Observable<[BookmarkResponse]> {
        let endPoint = BookmarkEndPoint.fetchItemBookmark(query: BookmarkItemQuery(jobId: jobId, minLevel: minLevel, maxLevel: maxLevel, categoryIds: categoryIds, sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }

    public func fetchMapBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        let endPoint = BookmarkEndPoint.fetchMapBookmark(query: SortedQuery(sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }
}

private extension BookmarkRepositoryImpl {
    struct SortedQuery: Encodable {
        let sort: String?
    }

    struct SetBookmarkQuery: Encodable {
        let bookmarkType: String
        let resourceId: Int
    }

    struct BookmarkMonsterQuery: Encodable {
        let minLevel: Int?
        let maxLevel: Int?
        let sort: String?
    }

    struct BookmarkItemQuery: Encodable {
        let jobId: Int?
        let minLevel: Int?
        let maxLevel: Int?
        let categoryIds: [Int]?
        let sort: String?
    }
}
