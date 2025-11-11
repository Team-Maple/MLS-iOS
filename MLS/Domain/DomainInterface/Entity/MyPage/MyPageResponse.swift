public struct MyPageResponse: Equatable {
    public var nickname: String
    public let jobId: Int?
    public var jobName: String
    public let level: Int?
    public let profileUrl: String
    public let platform: LoginPlatform
    public let noticeAgreement: Bool
    public let patchNoteAgreement: Bool
    public let eventAgreement: Bool

    public init(nickname: String, jobId: Int?, jobName: String, level: Int?, profileUrl: String, platform: LoginPlatform, noticeAgreement: Bool?, patchNoteAgreement: Bool?, eventAgreement: Bool?) {
        self.nickname = nickname
        self.jobId = jobId
        self.jobName = jobName
        self.level = level
        self.profileUrl = profileUrl
        self.platform = platform
        self.noticeAgreement = noticeAgreement ?? false
        self.patchNoteAgreement = patchNoteAgreement ?? false
        self.eventAgreement = eventAgreement ?? false
    }
}
