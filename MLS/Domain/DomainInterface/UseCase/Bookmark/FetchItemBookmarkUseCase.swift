import RxSwift

public protocol FetchItemBookmarkUseCase {
    func execute(jobId: Int?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, page: Int?, size: Int?, sort: SortType?) -> Observable<[BookmarkResponse]>
}
