import DomainInterface

public struct BookmarkDTO: Decodable {
    public let bookmarkId: Int
    public let originalId: Int
    public let name: String
    public let imageUrl: String
    public let type: String
    public let level: Int?

    public func toDomain() -> BookmarkResponse {
        guard let type = DictionaryItemType(rawValue: type) else {
            fatalError("타입이 없습니다.")
        }
        return BookmarkResponse(
            name: name,
            bookmarkId: bookmarkId,
            originalId: originalId,
            imageUrl: imageUrl,
            type: type,
            level: level
        )
    }
}

extension Array where Element == BookmarkDTO {
    func toDomain() -> [BookmarkResponse] {
        return self.map { $0.toDomain() }
    }
}
