import RxSwift

public protocol RecommendationUserDefaultsRepository {
    func saveFirstLaunch() -> Completable
}
