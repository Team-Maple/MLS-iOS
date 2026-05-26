import MLSCore
import MLSDictionaryFeatureInterface

import RxSwift

public final class MockBookmarkRepository: BookmarkRepository {

    public init() {}

    public func setBookmark(bookmarkId: Int, type: DictionaryItemType) -> Observable<Int> {
        return .just(bookmarkId)
    }

    public func deleteBookmark(bookmarkId: Int) -> Observable<Int?> {
        return .just(bookmarkId)
    }

    public func fetchBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        return .just([])
    }

    public func fetchMonsterBookmark(minLevel: Int?, maxLevel: Int?, sort: String?) -> Observable<[BookmarkResponse]> {
        return .just([])
    }

    public func fetchNPCBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        return .just([])
    }

    public func fetchQuestBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        return .just([])
    }

    public func fetchItemBookmark(jobId: Int?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, sort: String?) -> Observable<[BookmarkResponse]> {
        return .just([])
    }

    public func fetchMapBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        return .just([])
    }
}
