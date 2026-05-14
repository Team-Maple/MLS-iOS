public struct UserProfile {
    public let nickname: String
    public let jobId: Int?
    public let level: Int?
    public let profileImageUrl: String

    public init(nickname: String, jobId: Int?, level: Int?, profileImageUrl: String) {
        self.nickname = nickname
        self.jobId = jobId
        self.level = level
        self.profileImageUrl = profileImageUrl
    }
}
