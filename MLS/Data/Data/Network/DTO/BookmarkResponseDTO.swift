import DomainInterface

public struct BookmarkResponseDTO: Codable {
    public let data: BookmarkDataDTO
    
    public struct BookmarkDataDTO: Codable {
        public let bookmarkId: Int
        public let bookmarkType: String
        public let resourceId: Int
        
        public func toDomain() -> BookmarkData {
            return BookmarkData(bookmarkId: bookmarkId, bookmarkType: bookmarkType, resourceId: resourceId)
        }
    }
    
    public func toDomain() -> BookmarkResponse {
        return BookmarkResponse(data: self.data.toDomain())
    }
}


