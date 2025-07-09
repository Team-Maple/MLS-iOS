import DomainInterface

public enum AuthEndPoint {
    static let base = "https://api.mapleland.kro.kr"

    public static func loginWithKakao(credential: Credential) -> ResponsableEndPoint<AuthResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/login/kakao",
            method: .POST,
            headers: ["access-token": credential.token]
        )
    }

    public static func loginWithApple(credential: Credential) -> ResponsableEndPoint<AuthResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/login/apple",
            method: .POST,
            headers: ["id-token": credential.token]
        )
    }

    public static func signupWithKakao(credential: String, body: Encodable) -> ResponsableEndPoint<AuthResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/signup/kakao",
            method: .POST,
            headers: ["access-token": credential],
            body: body
        )
    }

    public static func signupWithApple(credential: String, body: Encodable) -> ResponsableEndPoint<AuthResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/signup/apple",
            method: .POST,
            headers: ["id-token": credential],
            body: body
        )
    }

    public static func reIssueToken(refreshToken: String) -> ResponsableEndPoint<AuthResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/reissue",
            method: .POST,
            headers: [
                "accept": "*/*",
                "refresh-token": refreshToken
            ]
        )
    }

    public static func fcmToken(body: Encodable) -> EndPoint {
        .init(
            baseURL: base,
            path: "/api/v1/auth/member/fcm-token",
            method: .PUT,
            body: body
        )
    }
}
