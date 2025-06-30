import DomainInterface

public enum AuthEndPoint {
    static let base = "https://api.mapleland.kro.kr"

    public static func loginWithKakao(credential: Credential) -> ResponsableEndPoint<APIResponseDTO<AuthResponseDTO>> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/login/kakao",
            method: .POST,
            headers: ["access_token": credential.token ?? ""]
        )
    }

    public static func loginWithApple(credential: Credential) -> ResponsableEndPoint<APIResponseDTO<AuthResponseDTO>> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/login/apple",
            method: .POST,
            query: ["id_token": credential.token]
        )
    }

    public static func signupWithKakao(id: String, nickname: String) -> ResponsableEndPoint<APIResponseDTO<AuthResponseDTO>> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/signup/kakao",
            method: .POST,
            body: SignupBody(providerId: id, provider: "KAKAO", nickname: nickname)
        )
    }

    public static func signupWithApple(id: String, nickname: String) -> ResponsableEndPoint<APIResponseDTO<AuthResponseDTO>> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/signup/apple",
            method: .POST,
            body: SignupBody(providerId: id, provider: "APPLE", nickname: nickname)
        )
    }
    
//    public static func reIssueToken(
//        accessToken: String,
//        refreshToken: String
//    ) -> ResponsableEndPoint<APIResponseDTO<AuthResponseDTO>> {
//        .init(
//            baseURL: base,
//            path: "/api/v1/auth/reissue",
//            method: .POST,
//            headers: [
//                "accept": "*/*",
//                "refresh_token": refreshToken,
//                "Authorization": "Bearer \(accessToken)"
//            ]
//        )
//    }
}

// MARK: - Query/Body Models
private struct LoginQuery: Encodable {
    let accessToken: String
}

private struct AppleLoginQuery: Encodable {
    let idToken: String
}

private struct SignupBody: Encodable {
    let providerId: String
    let provider: String
    let nickname: String
}
