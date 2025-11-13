import DomainInterface

public struct MemberDTO: Decodable {
    public let id: String
    public let provider: String
    public let nickname: String
    public let fcmToken: String?
    public let marketingAgreement: Bool?
    public let noticeAgreement: Bool?
    public let patchNoteAgreement: Bool?
    public let eventAgreement: Bool?
    public let jobId: Int?
    public let level: Int?
    public let profileImageUrl: String

    func toMyPageDomain() -> MyPageResponse {
        return .init(
            nickname: nickname,
            jobId: jobId,
            jobName: "",
            level: level,
            profileUrl: profileImageUrl,
            platform: provider == "APPLE" ? .apple : .kakao,
            noticeAgreement: noticeAgreement,
            patchNoteAgreement: patchNoteAgreement,
            eventAgreement: eventAgreement
        )
    }

}
