import RxSwift

public protocol FetchMapBookmarkUseCase {
    func execute(page: Int?, size: Int?, sort: SortType?) -> Observable<[BookmarkResponse]>
}
