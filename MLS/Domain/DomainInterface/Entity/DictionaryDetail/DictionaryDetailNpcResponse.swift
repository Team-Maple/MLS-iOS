public struct DictionaryDetailNpcResponse: Codable {
    public let npcId: Int
    public let nameKr: String
    public let nameEn: String
    public let iconUrlDetail: String?
    public let bookmarkId: Int?

    public init(npcId: Int, nameKr: String, nameEn: String, iconUrlDetail: String?, bookmarkId: Int?) {
        self.npcId = npcId
        self.nameKr = nameKr
        self.nameEn = nameEn
        self.iconUrlDetail = iconUrlDetail
        self.bookmarkId = bookmarkId
    }
}
