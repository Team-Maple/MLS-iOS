import RxSwift

public protocol FetchQuestBookmarkUseCase {
    func execute(sort: SortType?) -> Observable<[BookmarkResponse]>
}
