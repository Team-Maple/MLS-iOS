import DomainInterface

public struct AuthResponseDTO: Decodable {
    public let accessToken: String
    public let refreshToken: String
    public let member: Member?

    public struct Member: Decodable {
        public let id: String
        public let provider: String
        public let nickname: String
    }
}

extension AuthResponseDTO {
    public func toDomain() -> LoginResponse {
        return .init(
            isRegister: member != nil,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
