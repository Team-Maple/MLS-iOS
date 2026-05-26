public struct DictionaryMapDTO: DictionaryDTOProtocol {
    public let mapId: Int
    public let name: String
    public let imageUrl: String?
    public let level: Int?
    public let type: String
    public let bookmarkId: Int?
    public var id: Int { mapId }
    
    public init(mapId: Int, name: String, imageUrl: String?, level: Int?, type: String, bookmarkId: Int?) {
        self.mapId = mapId
        self.name = name
        self.imageUrl = imageUrl
        self.level = level
        self.type = type
        self.bookmarkId = bookmarkId
    }
}
