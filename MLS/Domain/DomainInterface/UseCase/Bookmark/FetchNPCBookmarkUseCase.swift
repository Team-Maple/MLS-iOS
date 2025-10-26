import RxSwift

public protocol FetchNPCBookmarkUseCase {
    func execute(sort: SortType?) -> Observable<[BookmarkResponse]>
}
