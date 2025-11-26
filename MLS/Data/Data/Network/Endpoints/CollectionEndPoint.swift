import DomainInterface

public enum CollectionEndPoint {
    static let base = "https://api.mapleland.kro.kr"

    public static func fetchCollectionList() -> ResponsableEndPoint<[CollectionListResponseDTO]> {
        .init(baseURL: base, path: "/api/v1/collections", method: .GET)
    }

    public static func createCollectionList(body: Encodable) -> EndPoint {
        .init(baseURL: base, path: "/api/v1/collections", method: .POST, body: body)
    }

    public static func fetchCollection(id: Int) -> ResponsableEndPoint<[BookmarkDTO]> {
        .init(
            baseURL: base,
            path: "/api/v1/collections/\(id)/bookmarks",
            method: .GET
        )
    }

    public static func addBookmarksToCollection(id: Int, body: Encodable) -> EndPoint {
        .init(
            baseURL: base,
            path: "/api/v1/collections/\(id)/bookmarks",
            method: .POST,
            body: body
        )
    }

    public static func addCollectionsToBookmark(id: Int, body: Encodable) -> EndPoint {
        .init(
            baseURL: base,
            path: "/api/v1/bookmarks/\(id)/collections",
            method: .POST,
            body: body
        )
    }
    
    public static func setCollectionName(id: Int, body: Encodable) -> EndPoint {
        .init(
            baseURL: base,
            path: "/api/v1/collections/\(id)",
            method: .PUT,
            body: body
        )
    }
}
