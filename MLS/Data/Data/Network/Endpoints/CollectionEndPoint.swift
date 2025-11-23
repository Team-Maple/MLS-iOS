import DomainInterface

public enum CollectionEndPoint {
    static let base = "https://api.mapleland.kro.kr"

    public static func fetchCollectionList() -> ResponsableEndPoint<[CollectionListResponseDTO]> {
        .init(baseURL: base, path: "/api/v1/collections", method: .GET)
    }

    public static func createCollectionList(body: Encodable) -> EndPoint {
        .init(baseURL: base, path: "/api/v1/collections", method: .POST, body: body)
    }
}
