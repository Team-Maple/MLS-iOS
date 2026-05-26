public struct DictionaryQuestDTO: DictionaryDTOProtocol {
    public let questId: Int
    public let name: String
    public let imageUrl: String?
    public let level: Int?
    public let type: String
    public let bookmarkId: Int?
    public var id: Int { questId }
    
    public init(questId: Int, name: String, imageUrl: String?, level: Int?, type: String, bookmarkId: Int?) {
        self.questId = questId
        self.name = name
        self.imageUrl = imageUrl
        self.level = level
        self.type = type
        self.bookmarkId = bookmarkId
    }
}
