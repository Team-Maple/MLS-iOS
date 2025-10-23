import RxSwift

public protocol FetchQuestBookmarkUseCase {
    func execute(page: Int?, size: Int?, sort: SortType?) -> Observable<[BookmarkResponse]>
}
