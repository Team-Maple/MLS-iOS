import MLSBookmarkFeatureInterface
import MLSCore
import RxSwift

public final class CollectionRepositoryImpl: CollectionRepository {
    private let provider: NetworkProvider
    private let interceptor: Interceptor

    public init() {
        self.provider = NetworkProviderImpl()
        self.interceptor = TokenInterceptor()
    }

    public func fetchCollectionList(sort: String?) -> Observable<[CollectionResponse]> {
        let endpoint = CollectionEndPoint.fetchCollectionList(query: FetchListQuery(sort: sort))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.map { $0.toDomain() } }
    }

    public func createCollectionList(name: String) -> Completable {
        let endpoint = CollectionEndPoint.createCollectionList(body: CreateBody(name: name))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
    }

    public func fetchCollection(id: Int) -> Observable<[BookmarkResponse]> {
        let endpoint = CollectionEndPoint.fetchCollection(id: id)
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.toDomain() }
    }

    public func updateCollectionName(collectionId: Int, name: String) -> Completable {
        let endpoint = CollectionEndPoint.setCollectionName(id: collectionId, body: UpdateNameBody(name: name))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
    }

    public func deleteCollection(collectionId: Int) -> Completable {
        let endpoint = CollectionEndPoint.deleteCollection(id: collectionId)
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
    }

    public func addCollectionAndBookmark(collectionIds: [Int], bookmarkIds: [Int]) -> Completable {
        let endpoint = CollectionEndPoint.addCollectionAndBookmark(body: AddBody(collectionIds: collectionIds, bookmarkIds: bookmarkIds))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
    }
}

private extension CollectionRepositoryImpl {
    struct FetchListQuery: Encodable {
        let sort: String?
    }

    struct CreateBody: Encodable {
        let name: String
    }

    struct UpdateNameBody: Encodable {
        let name: String
    }

    struct AddBody: Encodable {
        let collectionIds: [Int]
        let bookmarkIds: [Int]
    }
}
