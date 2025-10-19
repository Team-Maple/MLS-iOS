public struct MyPageResponse {
    public let nickname: String
    public let jobId: Int?
    public var jobName: String
    public let level: Int?
    public let profileUrl: String
    public let platform: LoginPlatform
    
    public init(nickname: String, jobId: Int?, jobName: String, level: Int?, profileUrl: String, platform: LoginPlatform) {
        self.nickname = nickname
        self.jobId = jobId
        self.jobName = jobName
        self.level = level
        self.profileUrl = profileUrl
        self.platform = platform
    }
}
