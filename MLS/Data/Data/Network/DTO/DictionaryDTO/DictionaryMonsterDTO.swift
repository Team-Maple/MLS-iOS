public struct DictionaryMonsterDTO: DictionaryDTOProtocol {
    public let monsterId: Int
    public let name: String
    public let imageUrl: String?
    public let level: Int?
    public let type: String
    public let bookmarkId: Int?
    public var id: Int { monsterId }
}
