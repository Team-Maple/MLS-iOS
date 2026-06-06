import MLSBookmarkFeatureInterface
import RxSwift

public final class MockBookmarkRepository: BookmarkRepository {
    public var setBookmarkResult: Observable<Int> = .just(0)
    public var deleteBookmarkResult: Observable<Int?> = .just(nil)
    public var fetchBookmarkResult: Observable<[BookmarkResponse]> = .just([])
    public var fetchMonsterBookmarkResult: Observable<[BookmarkResponse]> = .just([])
    public var fetchItemBookmarkResult: Observable<[BookmarkResponse]> = .just([])
    public var fetchNPCBookmarkResult: Observable<[BookmarkResponse]> = .just([])
    public var fetchQuestBookmarkResult: Observable<[BookmarkResponse]> = .just([])
    public var fetchMapBookmarkResult: Observable<[BookmarkResponse]> = .just([])

    public init() {}

    public func setBookmark(resourceId: Int, type: DictionaryItemType) -> Observable<Int> {
        setBookmarkResult
    }

    public func deleteBookmark(bookmarkId: Int) -> Observable<Int?> {
        deleteBookmarkResult
    }

    public func fetchBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        fetchBookmarkResult
    }

    public func fetchMonsterBookmark(minLevel: Int?, maxLevel: Int?, sort: String?) -> Observable<[BookmarkResponse]> {
        fetchMonsterBookmarkResult
    }

    public func fetchItemBookmark(jobId: Int?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, sort: String?) -> Observable<[BookmarkResponse]> {
        fetchItemBookmarkResult
    }

    public func fetchNPCBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        fetchNPCBookmarkResult
    }

    public func fetchQuestBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        fetchQuestBookmarkResult
    }

    public func fetchMapBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        fetchMapBookmarkResult
    }
}
