import Foundation

import DomainInterface

import RxSwift

public class CollectionAPIRepositoryImpl: CollectionAPIRepository {
    private let provider: NetworkProvider
    private let tokenInterceptor: Interceptor

    public init(provider: NetworkProvider, tokenInterceptor: Interceptor) {
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor
    }

    public func fetchCollectionList(sort: String?) -> Observable<[CollectionResponse]> {
        let endPoint = CollectionEndPoint.fetchCollectionList(query: FetchCollectionListQuery(sort: sort))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.map { $0.toDomain() }
            }
    }

    public func createCollectionList(name: String) -> Completable {
        let endPoint = CollectionEndPoint.createCollectionList(body: CreateCollectionRequestDTO(name: name))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
    }

    public func fetchCollectionUseCase(id: Int) -> Observable<[BookmarkResponse]> {
        let endPoint = CollectionEndPoint.fetchCollection(id: id)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
            .map { $0.toDomain() }
    }

    public func updateCollectionName(collectionId: Int, name: String) -> Completable {
        let endPoint = CollectionEndPoint.setCollectionName(id: collectionId, body: SetCollectionRequestBody(name: name))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
    }

    public func deleteCollection(collectionId: Int) -> Completable {
        let endPoint = CollectionEndPoint.deleteCollection(id: collectionId)
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
    }

    public func addCollectionAndBookmark(collectionIds: [Int], bookmarkIds: [Int]) -> Completable {
        let endPoint = CollectionEndPoint.addCollectionAndBookmark(body: AddCollectionAndBookmarkBody(collectionIds: collectionIds, bookmarkIds: bookmarkIds))
        return provider.requestData(endPoint: endPoint, interceptor: tokenInterceptor)
    }
}

private extension CollectionAPIRepositoryImpl {
    struct FetchCollectionListQuery: Encodable {
        let sort: String?
    }

    struct CreateCollectionRequestDTO: Encodable {
        let name: String
    }

    struct AddBookmarkRequestBody: Encodable {
        let bookmarkIds: [Int]
    }

    struct AddCollectionRequestBody: Encodable {
        let collectionIds: [Int]
    }

    struct SetCollectionRequestBody: Encodable {
        let name: String
    }

    struct AddCollectionAndBookmarkBody: Encodable {
        let collectionIds: [Int]
        let bookmarkIds: [Int]
    }
}
