import DomainInterface

public enum AuthEndPoint {
    static let base = "https://api.mapleland.kro.kr"

    public static func fetchProfile() -> ResponsableEndPoint<MemberDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/me",
            method: .GET
        )
    }

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

    public static func fcmToken(body: Encodable) -> ResponsableEndPoint<MemberDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/member/fcm-token",
            method: .PUT,
            body: body
        )
    }

    public static func withdraw() -> EndPoint {
        .init(
            baseURL: base,
            path: "/api/v1/auth/member",
            method: .DELETE
        )
    }

    public static func updateMarketingAgreement(credential: String, body: Encodable) -> ResponsableEndPoint<MemberDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/member/marketing-agreement",
            method: .PUT,
            headers: ["Authorization": "Bearer \(credential)"],
            body: body
        )
    }

    public static func fetchJobs() -> ResponsableEndPoint<[JobsDTO]> {
        .init(
            baseURL: base,
            path: "/api/v1/jobs",
            method: .GET
        )
    }

    public static func fetchJob(jobId: String) -> ResponsableEndPoint<JobsDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/jobs/\(jobId)",
            method: .GET
        )
    }

    public static func updateCharacterInfo(body: Encodable) -> ResponsableEndPoint<MemberDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/member/profile",
            method: .PUT,
            body: body
        )
    }

    public static func updateNotification(body: Encodable) -> ResponsableEndPoint<MemberDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/member/alert-agreement",
            method: .PUT,
            body: body
        )
    }

    public static func updateNickName(body: Encodable) -> ResponsableEndPoint<MemberDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/member/nickname",
            method: .PUT,
            body: body
        )
    }

    public static func updateProfileImage(body: Encodable) -> ResponsableEndPoint<MemberDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/member/profile-image",
            method: .PUT,
            body: body
        )
    }
}
