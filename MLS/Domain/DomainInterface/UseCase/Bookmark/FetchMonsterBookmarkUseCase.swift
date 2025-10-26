import RxSwift

public protocol FetchMonsterBookmarkUseCase {
    func execute(minLevel: Int?, maxLevel: Int?, sort: SortType?) -> Observable<[BookmarkResponse]>
}
