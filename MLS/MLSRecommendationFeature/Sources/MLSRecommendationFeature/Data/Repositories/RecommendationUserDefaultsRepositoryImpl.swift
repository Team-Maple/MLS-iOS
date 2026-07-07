import Foundation

import MLSRecommendationFeatureInterface

import RxSwift

public final class RecommendationUserDefaultsRepositoryImpl: RecommendationUserDefaultsRepository {
    private let recommendationkey = "recommendationkey"

    public init() {}

    public func saveFirstLaunch() -> Completable {
        UserDefaults.standard.set(true, forKey: recommendationkey)
        return .empty()
    }
}
