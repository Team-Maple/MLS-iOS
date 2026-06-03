public struct DictionaryMainResponse {
    public let totalPages: Int
    public let totalElements: Int
    public var contents: [DictionaryMainItemResponse]

    public init(totalPages: Int, totalElements: Int, contents: [DictionaryMainItemResponse]) {
        self.totalPages = totalPages
        self.totalElements = totalElements
        self.contents = contents
    }
}

public struct DictionaryMainItemResponse: Equatable {
    public let id: Int
    public let name: String
    public let imageUrl: String?
    public let level: Int?
    public let type: DictionaryItemType
    public var bookmarkId: Int?

    public init(id: Int, name: String, imageUrl: String?, level: Int?, type: DictionaryItemType, bookmarkId: Int?) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.level = level
        self.type = type
        self.bookmarkId = bookmarkId
    }
}
