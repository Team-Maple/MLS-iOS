import MLSBookmarkFeatureInterface
import MLSDictionaryFeatureInterface

struct BookmarkDTO: Decodable {
    let bookmarkId: Int
    let originalId: Int
    let name: String
    let imageUrl: String
    let type: String
    let level: Int?

    func toDomain() -> BookmarkResponse? {
        guard let type = DictionaryItemType(rawValue: type) else { return nil }
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
