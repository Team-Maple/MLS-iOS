public struct RecommendationMap {
    public let mapId: Int
    public let score: Int
    public let iconUrl: String
    public let nameKr: String
    public let bookmarkId: Int?

    public var isBookmarked: Bool { bookmarkId != nil }

    public init(mapId: Int, score: Int, iconUrl: String, nameKr: String, bookmarkId: Int?) {
        self.mapId = mapId
        self.score = score
        self.iconUrl = iconUrl
        self.nameKr = nameKr
        self.bookmarkId = bookmarkId
    }
}
