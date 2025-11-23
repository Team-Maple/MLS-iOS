import DomainInterface

public struct CollectionListResponseDTO: Decodable {
    public let collectionId: Int
    public let name: String
    public let createdAt: [Int]
    public let recentBookmarks: [BookmarkDTO]

    public func toDomain() -> CollectionResponse {
        return CollectionResponse(collectionId: collectionId, name: name, createdAt: createdAt, recentBookmarks: recentBookmarks.toDomain())
    }
}
