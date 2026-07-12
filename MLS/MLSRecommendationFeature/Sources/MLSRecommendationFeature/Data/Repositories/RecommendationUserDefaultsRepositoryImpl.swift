import Foundation

import MLSRecommendationFeatureInterface

import RxSwift

public final class RecommendationUserDefaultsRepositoryImpl: RecommendationUserDefaultsRepository {
    private let recommendationkey = "recommendationkey"

    public init() {}

    public func saveFirstLaunch() -> Completable {
        if !UserDefaults.standard.bool(forKey: recommendationkey) {
            UserDefaults.standard.set(true, forKey: recommendationkey)
        }
        return .empty()
    }
}
