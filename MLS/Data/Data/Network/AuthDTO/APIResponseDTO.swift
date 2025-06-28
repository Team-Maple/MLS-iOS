import DomainInterface

public struct APIResponseDTO<T: Decodable>: Decodable {
    public let success: Bool
    public let code: String?
    public let message: String?
    public let data: T?
}
