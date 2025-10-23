public struct DictionaryMainResponse {
    public let totalPages: Int
    public let totalElements: Int
    public let contents: [DictionaryMainItemResponse]

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
    public let type: DictionaryItemType
    public let isBookmarked: Bool

    public init(id: Int, name: String, imageUrl: String?, type: DictionaryItemType, isBookmarked: Bool) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.type = type
        self.isBookmarked = isBookmarked
    }
}
