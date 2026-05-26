public struct DictionaryNPCDTO: DictionaryDTOProtocol {
    public let npcId: Int
    public let name: String
    public let imageUrl: String?
    public let level: Int?
    public let type: String
    public let bookmarkId: Int?
    public var id: Int { npcId }
    
    public init(npcId: Int, name: String, imageUrl: String?, level: Int?, type: String, bookmarkId: Int?) {
        self.npcId = npcId
        self.name = name
        self.imageUrl = imageUrl
        self.level = level
        self.type = type
        self.bookmarkId = bookmarkId
    }
}
