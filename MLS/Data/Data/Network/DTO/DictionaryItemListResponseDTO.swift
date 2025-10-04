import DomainInterface

public struct DictionaryItemListResponseDTO: Codable {
    public let totalPages: Int
    public let totalElements: Int
    public let content: [DictionaryItemDTO]
    
    public struct DictionaryItemDTO: Codable {
        public let itemId: Int
        public let name: String
        public let imageUrl: String?
        public let type: String
        public let isBookmarked: Bool
        
        public func toDomain() -> DictionaryMainItemResponse {
            return DictionaryMainItemResponse(id: itemId, name: name, imageUrl: imageUrl, type: type, isBookmarked: isBookmarked)
        }
    }
    
    public func toDomain() -> DictionaryMainResponse {
        return DictionaryMainResponse(totalPages: totalPages, totalElements: totalElements, contents: content.map { $0.toDomain()}
        )
    }
}


