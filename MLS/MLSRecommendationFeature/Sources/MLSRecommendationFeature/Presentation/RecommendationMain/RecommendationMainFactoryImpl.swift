import UIKit

import MLSCore
import MLSRecommendationFeatureInterface

public struct RecommendationMainFactoryImpl: RecommendationMainFactory {
    private let repository: RecommendationRepository
    private let makeLoginVC: (() -> UIViewController)?
    private let makeCharacterSettingVC: (() -> UIViewController)?

    public init(
        repository: RecommendationRepository,
        makeLoginVC: (() -> UIViewController)? = nil,
        makeCharacterSettingVC: (() -> UIViewController)? = nil
    ) {
        self.repository = repository
        self.makeLoginVC = makeLoginVC
        self.makeCharacterSettingVC = makeCharacterSettingVC
    }

    public func make() -> BaseViewController {
        let vc = RecommendationMainViewController()
        vc.reactor = RecommendationMainReactor(repository: repository)
        vc.onLoginTapped = makeLoginVC
        vc.onEditTapped = makeCharacterSettingVC
        return vc
    }
}
