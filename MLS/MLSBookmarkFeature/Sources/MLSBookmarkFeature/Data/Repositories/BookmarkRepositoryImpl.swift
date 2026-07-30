import MLSBookmarkFeatureInterface
import MLSCore
import MLSDictionaryFeatureInterface

import RxSwift

public final class BookmarkRepositoryImpl: BookmarkRepository {
    private let provider: NetworkProvider
    private let interceptor: Interceptor

    public init() {
        self.provider = NetworkProviderImpl()
        self.interceptor = TokenInterceptor()
    }

    public func setBookmark(resourceId: Int, type: DictionaryItemType) -> Observable<Int> {
        let endpoint = BookmarkEndPoint.setBookmark(body: SetBookmarkBody(bookmarkType: type.rawValue, resourceId: resourceId))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.toDomain() }
    }

    public func deleteBookmark(bookmarkId: Int) -> Observable<Int?> {
        let endpoint = BookmarkEndPoint.deleteBookmark(bookmarkId: bookmarkId)
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.toBookmarkDomain() }
    }

    public func fetchBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        let endpoint = BookmarkEndPoint.fetchBookmark(query: SortQuery(sort: sort))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.toDomain() }
    }

    public func fetchMonsterBookmark(minLevel: Int?, maxLevel: Int?, sort: String?) -> Observable<[BookmarkResponse]> {
        let endpoint = BookmarkEndPoint.fetchMonsterBookmark(query: MonsterQuery(minLevel: minLevel, maxLevel: maxLevel, sort: sort))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.toDomain() }
    }

    public func fetchNPCBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        let endpoint = BookmarkEndPoint.fetchNPCBookmark(query: SortQuery(sort: sort))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.toDomain() }
    }

    public func fetchQuestBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        let endpoint = BookmarkEndPoint.fetchQuestBookmark(query: SortQuery(sort: sort))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.toDomain() }
    }

    public func fetchItemBookmark(jobId: Int?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, sort: String?) -> Observable<[BookmarkResponse]> {
        let endpoint = BookmarkEndPoint.fetchItemBookmark(query: ItemQuery(jobId: jobId, minLevel: minLevel, maxLevel: maxLevel, categoryIds: categoryIds, sort: sort))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.toDomain() }
    }

    public func fetchMapBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        let endpoint = BookmarkEndPoint.fetchMapBookmark(query: SortQuery(sort: sort))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.toDomain() }
    }
}

private extension BookmarkRepositoryImpl {
    struct SortQuery: Encodable {
        let sort: String?
    }

    struct SetBookmarkBody: Encodable {
        let bookmarkType: String
        let resourceId: Int
    }

    struct MonsterQuery: Encodable {
        let minLevel: Int?
        let maxLevel: Int?
        let sort: String?
    }

    struct ItemQuery: Encodable {
        let jobId: Int?
        let minLevel: Int?
        let maxLevel: Int?
        let categoryIds: [Int]?
        let sort: String?
    }
}
