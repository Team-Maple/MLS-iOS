import UIKit

import MLSCore
import MLSRecommendationFeatureInterface

public struct RecommendationMainFactoryImpl: RecommendationMainFactory {
    private let repository: RecommendationRepository
    private let makeLoginVC: (() -> UIViewController)?
    private let makeCharacterSettingVC: (() -> UIViewController)?
    private let makeSearchVC: (() -> UIViewController)?
    private let makeNotificationVC: (() -> UIViewController)?

    public init(
        repository: RecommendationRepository,
        makeLoginVC: (() -> UIViewController)? = nil,
        makeCharacterSettingVC: (() -> UIViewController)? = nil,
        makeSearchVC: (() -> UIViewController)? = nil,
        makeNotificationVC: (() -> UIViewController)? = nil
    ) {
        self.repository = repository
        self.makeLoginVC = makeLoginVC
        self.makeCharacterSettingVC = makeCharacterSettingVC
        self.makeSearchVC = makeSearchVC
        self.makeNotificationVC = makeNotificationVC
    }

    public func make() -> BaseViewController {
        let vc = RecommendationMainViewController()
        vc.reactor = RecommendationMainReactor(repository: repository)
        vc.onLoginTapped = makeLoginVC
        vc.onEditTapped = makeCharacterSettingVC
        vc.onSearchTapped = makeSearchVC
        vc.onNotificationTapped = makeNotificationVC
        return vc
    }
}
