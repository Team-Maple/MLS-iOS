import Foundation

import MLSBookmarkFeatureInterface
import MLSCore
import MLSDictionaryFeatureInterface

import RxSwift

public final class MockBookmarkFailRepository: BookmarkRepository {

    public init() {}

    private func failError<Element>() -> Observable<Element> {
        return Observable<Element>.error(
            NSError(
                domain: "MockBookmarkFailRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Mock failure error"]
            )
        )
    }

    public func setBookmark(resourceId: Int, type: DictionaryItemType) -> Observable<Int> {
        return failError()
    }

    public func deleteBookmark(bookmarkId: Int) -> Observable<Int?> {
        return failError()
    }

    public func fetchBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        return failError()
    }

    public func fetchMonsterBookmark(minLevel: Int?, maxLevel: Int?, sort: String?) -> Observable<[BookmarkResponse]> {
        return failError()
    }

    public func fetchNPCBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        return failError()
    }

    public func fetchQuestBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        return failError()
    }

    public func fetchItemBookmark(jobId: Int?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, sort: String?) -> Observable<[BookmarkResponse]> {
        return failError()
    }

    public func fetchMapBookmark(sort: String?) -> Observable<[BookmarkResponse]> {
        return failError()
    }
}
