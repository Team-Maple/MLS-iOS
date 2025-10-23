import RxSwift

public protocol FetchNPCBookmarkUseCase {
    func execute(page: Int?, size: Int?, sort: SortType?) -> Observable<[BookmarkResponse]>
}
