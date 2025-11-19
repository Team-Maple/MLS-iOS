import RxSwift

public protocol FetchCollectionListUseCase {
    func execute() -> Observable<[CollectionListResponse]>
}
