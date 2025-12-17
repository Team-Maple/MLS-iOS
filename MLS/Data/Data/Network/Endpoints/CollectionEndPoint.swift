import DomainInterface

public enum CollectionEndPoint {
    static let base = "https://api.mapleland.kro.kr"

    public static func fetchCollectionList(query: Encodable) -> ResponsableEndPoint<[CollectionListResponseDTO]> {
        .init(
            baseURL: base,
            path: "/api/v1/collections",
            method: .GET,
            query: query
        )
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

    public static func setCollectionName(id: Int, body: Encodable) -> EndPoint {
        .init(
            baseURL: base,
            path: "/api/v1/collections/\(id)",
            method: .PUT,
            body: body
        )
    }

    public static func deleteCollection(id: Int) -> EndPoint {
        .init(
            baseURL: base,
            path: "/api/v1/collections/\(id)",
            method: .DELETE
        )
    }

    public static func addCollectionAndBookmark(body: Encodable) -> EndPoint {
        .init(
            baseURL: base,
            path: "/api/v1/bookmark-collections",
            method: .POST,
            body: body
        )
    }
}
