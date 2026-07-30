import RxSwift

public protocol RecommendationRepository {
    func fetchProfile() -> Observable<UserProfile>
    func fetchJobName(jobId: Int) -> Observable<String>
    func fetchRecommendations(level: Int, jobId: Int, limit: Int?) -> Observable<[RecommendationMap]>
}
