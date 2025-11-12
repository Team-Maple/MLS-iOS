import DomainInterface

public struct SearchCountDTO: Decodable {
    public let counts: Int?

    public func toDomain() -> SearchCountResponse {
        return SearchCountResponse(count: counts)
    }
}
