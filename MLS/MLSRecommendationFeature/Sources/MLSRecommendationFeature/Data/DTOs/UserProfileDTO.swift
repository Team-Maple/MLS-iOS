import MLSRecommendationFeatureInterface

struct UserProfileDTO: Decodable {
    let id: String
    let provider: String
    let nickname: String
    let fcmToken: String?
    let marketingAgreement: Bool?
    let noticeAgreement: Bool?
    let patchNoteAgreement: Bool?
    let eventAgreement: Bool?
    let jobId: Int?
    let level: Int?
    let profileImageUrl: String
}

extension UserProfileDTO {
    func toDomain() -> UserProfile {
        UserProfile(
            nickname: nickname,
            jobId: jobId,
            level: level,
            profileImageUrl: profileImageUrl
        )
    }
}
