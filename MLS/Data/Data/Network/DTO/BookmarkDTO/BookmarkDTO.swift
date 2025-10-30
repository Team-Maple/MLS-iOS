import DomainInterface

public struct BookmarkDTO: Decodable {
    public let bookmarkId: Int
    public let originalId: Int
    public let name: String
    public let imageUrl: String
    public let type: String
    public let level: Int?

    public func toDomain() -> BookmarkResponse? {
        guard let type = DictionaryItemType(rawValue: type) else {
            return nil
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
        return self.compactMap { $0.toDomain() }
    }
}
