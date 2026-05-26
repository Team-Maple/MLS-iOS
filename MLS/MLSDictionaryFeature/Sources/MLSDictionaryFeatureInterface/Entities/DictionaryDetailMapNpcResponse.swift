public struct DictionaryDetailMapNpcResponse: Equatable {
    public let npcId: Int?
    public let npcName: String?
    public let npcNameEn: String?
    public let iconUrl: String?

    public init(npcId: Int?, npcName: String?, npcNameEn: String?, iconUrl: String?) {
        self.npcId = npcId
        self.npcName = npcName
        self.npcNameEn = npcNameEn
        self.iconUrl = iconUrl
    }
}
