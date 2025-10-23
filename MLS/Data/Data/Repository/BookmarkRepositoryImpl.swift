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

    public func setBookmark(bookmarkId: Int, type: DictionaryItemType) -> Completable {
        let endPoint = BookmarkEndPoint.setBookmark(body: SetBookmarkQuery(bookmarkType: type.rawValue, resourceId: bookmarkId))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
    }

    public func deleteBookmark(bookmarkId: Int) -> Completable {
        let endPoint = BookmarkEndPoint.deleteBookmark(bookmarkId: bookmarkId)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
    }

    public func fetchBookmark(page: Int, size: Int, sort: String?) -> Observable<[BookmarkResponse]> {
        let endPoint = BookmarkEndPoint.fetchBookmark(query: PagedQuery(page: page, size: size, sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }

    public func fetchMonsterBookmark(minLevel: Int?, maxLevel: Int?, page: Int, size: Int, sort: String?) -> Observable<[BookmarkResponse]> {
        let endPoint = BookmarkEndPoint.fetchMonsterBookmark(query: PagedQuery(page: page, size: size, sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }

    public func fetchNPCBookmark(page: Int, size: Int, sort: String?) -> Observable<[BookmarkResponse]> {
        let endPoint = BookmarkEndPoint.fetchNPCBookmark(query: PagedQuery(page: page, size: size, sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }

    public func fetchQuestBookmark(page: Int, size: Int, sort: String?) -> Observable<[BookmarkResponse]> {
        let endPoint = BookmarkEndPoint.fetchQuestBookmark(query: PagedQuery(page: page, size: size, sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }

    public func fetchItemBookmark(jobId: Int?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, page: Int, size: Int, sort: String?) -> Observable<[BookmarkResponse]> {
        let endPoint = BookmarkEndPoint.fetchItemBookmark(query: BookmarkItemQuery(jobId: jobId, minLevel: minLevel, maxLevel: maxLevel, categoryIds: categoryIds, page: page, size: size, sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }

    public func fetchMapBookmark(page: Int, size: Int, sort: String?) -> Observable<[BookmarkResponse]> {
        let endPoint = BookmarkEndPoint.fetchNPCBookmark(query: PagedQuery(page: page, size: size, sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }
}

private extension BookmarkRepositoryImpl {
    struct PagedQuery: Encodable {
        let page: Int
        let size: Int
        let sort: String?
    }

    struct SetBookmarkQuery: Encodable {
        let bookmarkType: String
        let resourceId: Int
    }

    struct BookmarkItemQuery: Encodable {
        let jobId: Int?
        let minLevel: Int?
        let maxLevel: Int?
        let categoryIds: [Int]?
        let page: Int
        let size: Int
        let sort: String?
    }
}
