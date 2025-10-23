public struct DictionaryNPCDTO: DictionaryDTOProtocol {
    public let npcId: Int
    public let name: String
    public let imageUrl: String?
    public let type: String
    public let isBookmarked: Bool
    public var id: Int { npcId }
}
