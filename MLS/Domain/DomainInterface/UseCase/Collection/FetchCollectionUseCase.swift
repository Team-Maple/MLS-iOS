import RxSwift

public protocol FetchCollectionUseCase {
    func execute(id: Int) -> Observable<[BookmarkResponse]>
}
