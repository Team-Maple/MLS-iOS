import RxSwift

/// Bookmark 모듈 분리 후 제거
public struct BookmarkResponse: Equatable {
    public let name: String
    public let bookmarkId: Int
    public let originalId: Int
    public let imageUrl: String?
    public let type: DictionaryItemType
    public let level: Int?

    public init(name: String, bookmarkId: Int, originalId: Int, imageUrl: String?, type: DictionaryItemType, level: Int?) {
        self.name = name
        self.bookmarkId = bookmarkId
        self.originalId = originalId
        self.imageUrl = imageUrl
        self.type = type
        self.level = level
    }
}

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
