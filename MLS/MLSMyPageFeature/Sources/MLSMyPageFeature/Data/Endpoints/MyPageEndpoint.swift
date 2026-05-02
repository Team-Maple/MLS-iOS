import MLSCore
import MLSMyPageFeatureInterface

public enum MyPageEndpoint {
    static let base = "https://mapleland.2megabytes.me"

    public static func fetchProfile() -> ResponsableEndPoint<MemberDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/me",
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
