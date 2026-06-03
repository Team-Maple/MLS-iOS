public struct DictionaryMonsterDTO: DictionaryDTOProtocol {
    public let monsterId: Int
    public let name: String
    public let imageUrl: String?
    public let level: Int?
    public let type: String
    public let bookmarkId: Int?
    public var id: Int { monsterId }

    public init(monsterId: Int, name: String, imageUrl: String?, level: Int?, type: String, bookmarkId: Int?) {
        self.monsterId = monsterId
        self.name = name
        self.imageUrl = imageUrl
        self.level = level
        self.type = type
        self.bookmarkId = bookmarkId
    }
}
