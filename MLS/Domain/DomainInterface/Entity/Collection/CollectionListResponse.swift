public struct CollectionListResponse {
    public let collectionId: Int
    public let name: String
    public let createdAt: [Int]
    public let recentBookmarks: [BookmarkResponse]

    public init(collectionId: Int, name: String, createdAt: [Int], recentBookmarks: [BookmarkResponse]) {
        self.collectionId = collectionId
        self.name = name
        self.createdAt = createdAt
        self.recentBookmarks = recentBookmarks
    }
}
