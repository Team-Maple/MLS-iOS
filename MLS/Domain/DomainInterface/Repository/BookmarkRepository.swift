import Foundation

import RxSwift

public protocol BookmarkRepository {
    func setBookmark(bookmarkId: Int, type: DictionaryItemType) -> Completable

    func deleteBookmark(bookmarkId: Int) -> Completable

    func fetchBookmark(page: Int, size: Int, sort: String?) -> Observable<[BookmarkResponse]>

    func fetchMonsterBookmark(minLevel: Int?, maxLevel: Int?, page: Int, size: Int, sort: String?) -> Observable<[BookmarkResponse]>

    func fetchNPCBookmark(page: Int, size: Int, sort: String?) -> Observable<[BookmarkResponse]>

    func fetchQuestBookmark(page: Int, size: Int, sort: String?) -> Observable<[BookmarkResponse]>

    func fetchItemBookmark(jobId: Int?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, page: Int, size: Int, sort: String?) -> Observable<[BookmarkResponse]>

    func fetchMapBookmark(page: Int, size: Int, sort: String?) -> Observable<[BookmarkResponse]>
}
