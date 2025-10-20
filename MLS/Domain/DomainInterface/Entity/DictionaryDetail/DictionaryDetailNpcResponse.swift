public struct DictionaryDetailNpcResponse: Codable {
    public let npcId: Int
    public let nameKr: String
    public let nameEn: String
    public let iconUrlDetail: String?
    public let isBookmarked: Bool

    public init(npcId: Int, nameKr: String, nameEn: String, iconUrlDetail: String?, isBookmarked: Bool) {
        self.npcId = npcId
        self.nameKr = nameKr
        self.nameEn = nameEn
        self.iconUrlDetail = iconUrlDetail
        self.isBookmarked = isBookmarked
    }
}
