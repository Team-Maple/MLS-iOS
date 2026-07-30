import MLSCore

enum BookmarkEndPoint {
    private static let base = "https://mapleland.2megabytes.me"

    static func setBookmark(body: Encodable) -> ResponsableEndPoint<SetBookmarkDTO> {
        .init(baseURL: base, path: "/api/v1/bookmarks", method: .POST, body: body)
    }

    static func deleteBookmark(bookmarkId: Int) -> ResponsableEndPoint<EmptyResponseDTO> {
        .init(baseURL: base, path: "/api/v1/bookmarks/\(bookmarkId)", method: .DELETE)
    }

    static func fetchBookmark(query: Encodable) -> ResponsableEndPoint<[BookmarkDTO]> {
        .init(baseURL: base, path: "/api/v1/bookmarks", method: .GET, query: query)
    }

    static func fetchMonsterBookmark(query: Encodable) -> ResponsableEndPoint<[BookmarkDTO]> {
        .init(baseURL: base, path: "/api/v1/bookmarks/monsters", method: .GET, query: query)
    }

    static func fetchNPCBookmark(query: Encodable) -> ResponsableEndPoint<[BookmarkDTO]> {
        .init(baseURL: base, path: "/api/v1/bookmarks/npcs", method: .GET, query: query)
    }

    static func fetchQuestBookmark(query: Encodable) -> ResponsableEndPoint<[BookmarkDTO]> {
        .init(baseURL: base, path: "/api/v1/bookmarks/quests", method: .GET, query: query)
    }

    static func fetchItemBookmark(query: Encodable) -> ResponsableEndPoint<[BookmarkDTO]> {
        .init(baseURL: base, path: "/api/v1/bookmarks/items", method: .GET, query: query)
    }

    static func fetchMapBookmark(query: Encodable) -> ResponsableEndPoint<[BookmarkDTO]> {
        .init(baseURL: base, path: "/api/v1/bookmarks/maps", method: .GET, query: query)
    }
}
