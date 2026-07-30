public struct DictionaryDetailMapSpawnMonsterResponse: Equatable {
    public let monsterId: Int?
    public let monsterName: String?
    public let level: Int?
    public let maxSpawnCount: Int?
    public let imageUrl: String?

    public init(monsterId: Int?, monsterName: String?, level: Int?, maxSpawnCount: Int?, imageUrl: String?) {
        self.monsterId = monsterId
        self.monsterName = monsterName
        self.level = level
        self.maxSpawnCount = maxSpawnCount
        self.imageUrl = imageUrl
    }
}
