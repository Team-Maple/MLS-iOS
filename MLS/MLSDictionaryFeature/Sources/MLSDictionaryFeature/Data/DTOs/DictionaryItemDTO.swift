public struct DictionaryItemDTO: DictionaryDTOProtocol {
    public let itemId: Int
    public let name: String
    public let imageUrl: String?
    public let level: Int?
    public let type: String
    public let bookmarkId: Int?
    public var id: Int { itemId }

    public init(itemId: Int, name: String, imageUrl: String?, level: Int?, type: String, bookmarkId: Int?) {
        self.itemId = itemId
        self.name = name
        self.imageUrl = imageUrl
        self.level = level
        self.type = type
        self.bookmarkId = bookmarkId
    }
}
