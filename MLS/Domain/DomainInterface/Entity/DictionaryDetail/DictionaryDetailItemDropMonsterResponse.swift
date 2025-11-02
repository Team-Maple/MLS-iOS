public struct DictionaryDetailItemDropMonsterResponse: Equatable {
    public let monsterId: Int?
    public let monsterName: String?
    public let level: Int?
    public let dropRate: Double?
    public let imageUrl: String?

    public init(monsterId: Int?, monsterName: String?, level: Int?, dropRate: Double?, imageUrl: String?) {
        self.monsterId = monsterId
        self.monsterName = monsterName
        self.level = level
        self.dropRate = dropRate
        self.imageUrl = imageUrl
    }
}
