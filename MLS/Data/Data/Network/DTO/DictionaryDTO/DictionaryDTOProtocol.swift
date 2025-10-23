import DomainInterface

public protocol DictionaryDTOProtocol: Decodable {
    var id: Int { get }
    var name: String { get }
    var imageUrl: String? { get }
    var type: String { get }
    var isBookmarked: Bool { get }

    func toDomain() -> DictionaryMainItemResponse
}

extension DictionaryDTOProtocol {
    public func toDomain() -> DictionaryMainItemResponse {
        if let type = DictionaryItemType(rawValue: type) {
            DictionaryMainItemResponse(
                id: id,
                name: name,
                imageUrl: imageUrl,
                type: type,
                isBookmarked: isBookmarked
            )
        } else {
            fatalError("타입이 없어요.")
        }
    }
}
