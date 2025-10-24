import DomainInterface

public protocol DictionaryDTOProtocol: Decodable {
    var id: Int { get }
    var name: String { get }
    var imageUrl: String? { get }
    var level: Int? { get }
    var type: String { get }
    var bookmarkId: Int? { get }

    func toDomain() -> DictionaryMainItemResponse?
}

extension DictionaryDTOProtocol {
    public func toDomain() -> DictionaryMainItemResponse? {
        if let type = DictionaryItemType(rawValue: type) {
            return DictionaryMainItemResponse(
                id: id,
                name: name,
                imageUrl: imageUrl, level: level,
                type: type,
                bookmarkId: bookmarkId
            )
        } else {
            return nil
        }
    }
}
