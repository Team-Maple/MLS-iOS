public struct DictionaryMapDTO: DictionaryDTOProtocol {
    public let mapId: Int
    public let name: String
    public let imageUrl: String?
    public let type: String
    public let isBookmarked: Bool
    public var id: Int { mapId }
}
