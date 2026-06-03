import MLSDictionaryFeatureInterface

public struct PagedListResponseDTO<Item: Decodable>: Decodable {
    public let totalPages: Int
    public let totalElements: Int
    public let content: [Item]

    public init(totalPages: Int, totalElements: Int, content: [Item]) {
        self.totalPages = totalPages
        self.totalElements = totalElements
        self.content = content
    }
}

public extension PagedListResponseDTO where Item: DictionaryDTOProtocol {
    func toDomain() -> DictionaryMainResponse {
        DictionaryMainResponse(
            totalPages: totalPages,
            totalElements: totalElements,
            contents: content.compactMap { $0.toDomain() }
        )
    }
}
