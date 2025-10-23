import RxSwift

public protocol FetchBookmarkUseCase {
    func execute(page: Int, size: Int, sort: SortType?) -> Observable<[BookmarkResponse]>
}
