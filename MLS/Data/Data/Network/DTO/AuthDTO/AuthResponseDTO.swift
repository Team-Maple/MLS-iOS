import DomainInterface

public struct AuthResponseDTO: Decodable {
    public let accessToken: String
    public let refreshToken: String
    public let member: MemberDTO?
}

public extension AuthResponseDTO {
    func toLoginDomain() -> LoginResponse {
        return .init(
            isRegister: member != nil,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }

    func toSignUpDomain() -> SignUpResponse {
        return .init(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
