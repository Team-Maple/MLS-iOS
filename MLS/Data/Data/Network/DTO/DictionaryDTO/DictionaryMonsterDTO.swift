public struct DictionaryMonsterDTO: DictionaryDTOProtocol {
    public let monsterId: Int
    public let name: String
    public let imageUrl: String?
    public let type: String
    public let isBookmarked: Bool
    public var id: Int { monsterId }
}
