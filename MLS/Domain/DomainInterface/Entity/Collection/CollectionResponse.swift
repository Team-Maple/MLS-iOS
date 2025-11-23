public struct CollectionResponse: Equatable {
    public let collectionId: Int
    public var name: String
    public let createdAt: [Int]
    public var recentBookmarks: [BookmarkResponse]

    public init(collectionId: Int, name: String, createdAt: [Int], recentBookmarks: [BookmarkResponse]) {
        self.collectionId = collectionId
        self.name = name
        self.createdAt = createdAt
        self.recentBookmarks = recentBookmarks
    }
}
