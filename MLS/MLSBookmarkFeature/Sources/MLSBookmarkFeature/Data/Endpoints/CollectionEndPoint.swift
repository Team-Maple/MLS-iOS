import MLSCore

enum CollectionEndPoint {
    private static let base = "https://mapleland.2megabytes.me"

    static func fetchCollectionList(query: Encodable) -> ResponsableEndPoint<[CollectionListResponseDTO]> {
        .init(baseURL: base, path: "/api/v1/collections", method: .GET, query: query)
    }

    static func createCollectionList(body: Encodable) -> EndPoint {
        .init(baseURL: base, path: "/api/v1/collections", method: .POST, body: body)
    }

    static func fetchCollection(id: Int) -> ResponsableEndPoint<[BookmarkDTO]> {
        .init(baseURL: base, path: "/api/v1/collections/\(id)/bookmarks", method: .GET)
    }

    static func setCollectionName(id: Int, body: Encodable) -> EndPoint {
        .init(baseURL: base, path: "/api/v1/collections/\(id)", method: .PUT, body: body)
    }

    static func deleteCollection(id: Int) -> EndPoint {
        .init(baseURL: base, path: "/api/v1/collections/\(id)", method: .DELETE)
    }

    static func addCollectionAndBookmark(body: Encodable) -> EndPoint {
        .init(baseURL: base, path: "/api/v1/bookmark-collections", method: .POST, body: body)
    }
}
