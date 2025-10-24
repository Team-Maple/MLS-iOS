public struct DictionaryItemDTO: DictionaryDTOProtocol {
    public let itemId: Int
    public let name: String
    public let imageUrl: String?
    public let type: String
    public let bookmarkId: Int?
    public var id: Int { itemId }
}
