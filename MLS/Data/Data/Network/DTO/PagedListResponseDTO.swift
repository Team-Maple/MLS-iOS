import DomainInterface

public struct PagedListResponseDTO<Item: Decodable>: Decodable {
    public let totalPages: Int
    public let totalElements: Int
    public let content: [Item]
}

extension PagedListResponseDTO where Item: DictionaryDTOProtocol {
    public func toDomain() -> DictionaryMainResponse {
        DictionaryMainResponse(
            totalPages: totalPages,
            totalElements: totalElements,
            contents: content.compactMap { $0.toDomain() }
        )
    }
}
