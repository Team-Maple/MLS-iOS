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
