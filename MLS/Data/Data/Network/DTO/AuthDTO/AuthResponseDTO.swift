import DomainInterface

public struct AuthResponseDTO: Decodable {
    public let accessToken: String
    public let refreshToken: String
    public let member: Member?

    public struct Member: Decodable {
        public let id: String
        public let provider: String
        public let nickname: String
        public let fcmToken: String?
        public let marketingAgreement: Bool?
        public let noticeAgreement: Bool?
        public let patchNoteAgreement: Bool?
        public let eventAgreement: Bool?
        public let jobId: Int?
        public let levle: Int?
        public let profileImageUrl: String
    }
}

extension AuthResponseDTO {
    public func toLoginDomain() -> LoginResponse {
        return .init(
            isRegister: member != nil,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }

    public func toSignUpDomain() -> SignUpResponse {
        return .init(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
