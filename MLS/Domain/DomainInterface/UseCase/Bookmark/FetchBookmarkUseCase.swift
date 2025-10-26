import RxSwift

public protocol FetchBookmarkUseCase {
    func execute(sort: SortType?) -> Observable<[BookmarkResponse]>
}
