import MLSBookmarkFeatureInterface

struct CollectionListResponseDTO: Decodable {
    let collectionId: Int
    let name: String
    let createdAt: [Int]
    let recentBookmarks: [BookmarkDTO]

    func toDomain() -> CollectionResponse {
        return CollectionResponse(
            collectionId: collectionId,
            name: name,
            createdAt: createdAt,
            recentBookmarks: recentBookmarks.toDomain()
        )
    }
}
