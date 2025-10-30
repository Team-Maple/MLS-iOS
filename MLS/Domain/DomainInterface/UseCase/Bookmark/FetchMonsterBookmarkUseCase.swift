import RxSwift

public protocol FetchMonsterBookmarkUseCase {
    func execute(minLevel: Int?, maxLevel: Int?, page: Int?, size: Int?, sort: SortType?) -> Observable<[BookmarkResponse]>
}
