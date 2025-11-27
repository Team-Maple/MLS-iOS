import RxSwift

public protocol FetchCollectionListUseCase {
    func execute(sort: SortType?) -> Observable<[CollectionResponse]>
}
