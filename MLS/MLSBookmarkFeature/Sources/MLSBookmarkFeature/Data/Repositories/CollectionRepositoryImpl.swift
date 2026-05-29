import MLSBookmarkFeatureInterface
import MLSCore
import RxSwift

final class CollectionRepositoryImpl: CollectionRepository {
    private let provider: NetworkProvider
    private let interceptor: Interceptor

    init() {
        self.provider = NetworkProviderImpl()
        self.interceptor = TokenInterceptor()
    }

    func fetchCollectionList(sort: String?) -> Observable<[CollectionResponse]> {
        let endpoint = CollectionEndPoint.fetchCollectionList(query: FetchListQuery(sort: sort))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.map { $0.toDomain() } }
    }

    func createCollectionList(name: String) -> Completable {
        let endpoint = CollectionEndPoint.createCollectionList(body: CreateBody(name: name))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
    }

    func fetchCollection(id: Int) -> Observable<[BookmarkResponse]> {
        let endpoint = CollectionEndPoint.fetchCollection(id: id)
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.toDomain() }
    }

    func updateCollectionName(collectionId: Int, name: String) -> Completable {
        let endpoint = CollectionEndPoint.setCollectionName(id: collectionId, body: UpdateNameBody(name: name))
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
    }

    func deleteCollection(collectionId: Int) -> Completable {
        let endpoint = CollectionEndPoint.deleteCollection(id: collectionId)
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
    }

    func addCollectionAndBookmark(collectionIds: [Int], bookmarkIds: [Int]) -> Completable {
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
