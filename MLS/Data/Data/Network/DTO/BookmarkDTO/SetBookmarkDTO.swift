import DomainInterface

public struct SetBookmarkDTO: Decodable {
    public let bookmarkId: Int
    public let bookmarkType: String
    public let resourceId: Int

    public func toDomain() -> Int {
        return self.bookmarkId
    }
}
