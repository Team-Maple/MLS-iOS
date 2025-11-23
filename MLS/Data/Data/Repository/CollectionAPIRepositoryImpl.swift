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

    public func fetchCollectionList() -> Observable<[CollectionResponse]> {
        let endPoint = CollectionEndPoint.fetchCollectionList()
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
}

private extension CollectionAPIRepositoryImpl {
    struct CreateCollectionRequestDTO: Encodable {
        let name: String
    }
}
