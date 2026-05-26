public struct DictionaryAllDTO: DictionaryDTOProtocol {
    public let originalId: Int
    public let name: String
    public let imageUrl: String?
    public let level: Int?
    public let type: String
    public let bookmarkId: Int?
    public var id: Int { originalId }
    
    public init(originalId: Int, name: String, imageUrl: String?, level: Int?, type: String, bookmarkId: Int?) {
        self.originalId = originalId
        self.name = name
        self.imageUrl = imageUrl
        self.level = level
        self.type = type
        self.bookmarkId = bookmarkId
    }
}
