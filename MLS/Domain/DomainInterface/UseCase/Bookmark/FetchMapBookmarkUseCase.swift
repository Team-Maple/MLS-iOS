import RxSwift

public protocol FetchMapBookmarkUseCase {
    func execute(sort: SortType?) -> Observable<[BookmarkResponse]>
}
