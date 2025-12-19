import Foundation

import RxSwift

public protocol BookmarkRepository {
    func setBookmark(bookmarkId: Int, type: DictionaryItemType) -> Observable<Int>

    func deleteBookmark(bookmarkId: Int) -> Observable<Int?>

    func fetchBookmark(sort: String?) -> Observable<[BookmarkResponse]>

    func fetchMonsterBookmark(minLevel: Int?, maxLevel: Int?, sort: String?) -> Observable<[BookmarkResponse]>

    func fetchNPCBookmark(sort: String?) -> Observable<[BookmarkResponse]>

    func fetchQuestBookmark(sort: String?) -> Observable<[BookmarkResponse]>

    func fetchItemBookmark(jobId: Int?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, sort: String?) -> Observable<[BookmarkResponse]>

    func fetchMapBookmark(sort: String?) -> Observable<[BookmarkResponse]>
}
