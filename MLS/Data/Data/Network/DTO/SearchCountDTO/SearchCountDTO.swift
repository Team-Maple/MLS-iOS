import DomainInterface

public struct SearchCountDTO: Codable {
    public let counts: Int?
    
    public func toDomain() -> SearchCountResponse {
        return SearchCountResponse(count: counts)
    }
}
