public struct ItemFilterCriteria {
    public let jobIds: [Int]
    public let startLevel: Int?
    public let endLevel: Int?
    public let categoryIds: [Int]

    public init(jobIds: [Int], startLevel: Int?, endLevel: Int?, categoryIds: [Int]) {
        self.jobIds = jobIds
        self.startLevel = startLevel
        self.endLevel = endLevel
        self.categoryIds = categoryIds
    }
}
