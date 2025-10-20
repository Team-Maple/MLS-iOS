import DomainInterface

public struct DictionaryMapListResponseDTO: Codable {
    public let totalPages: Int
    public let totalElements: Int
    public let content: [DictionaryItemDTO]

    public struct DictionaryItemDTO: Codable {
        public let mapId: Int
        public let name: String
        public let imageUrl: String?
        public let type: String
        public let isBookmarked: Bool

        public func toDomain() -> DictionaryMainItemResponse {
            return DictionaryMainItemResponse(id: mapId, name: name, imageUrl: imageUrl, type: type, isBookmarked: isBookmarked)
        }
    }

    public func toDomain() -> DictionaryMainResponse {
        return DictionaryMainResponse(totalPages: totalPages, totalElements: totalElements, contents: content.map { $0.toDomain()})
    }
}
