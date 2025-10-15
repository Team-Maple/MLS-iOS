public struct BookmarkResponse: Equatable {
    public let data: BookmarkData

    public init(data: BookmarkData) {
        self.data = data
    }
}
public struct BookmarkData: Equatable {
    public let bookmarkId: Int
    public let bookmarkType: String
    public let resourceId: Int

    public init(bookmarkId: Int, bookmarkType: String, resourceId: Int) {
        self.bookmarkId = bookmarkId
        self.bookmarkType = bookmarkType
        self.resourceId = resourceId
    }
}
