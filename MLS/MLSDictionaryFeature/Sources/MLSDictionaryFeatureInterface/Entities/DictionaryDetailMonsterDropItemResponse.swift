public struct DictionaryDetailMonsterDropItemResponse: Equatable {
    public let itemId: Int
    public let itemName: String
    public let dropRate: Double
    public let imageUrl: String
    public let itemLevel: Int

    public init(itemId: Int, itemName: String, dropRate: Double, imageUrl: String, itemLevel: Int) {
        self.itemId = itemId
        self.itemName = itemName
        self.dropRate = dropRate
        self.imageUrl = imageUrl
        self.itemLevel = itemLevel
    }
}
