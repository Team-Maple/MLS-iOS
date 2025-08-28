import BaseFeature
import DictionaryFeatureInterface

public final class MonsterDictionaryDetailFactoryImpl: MonsterDictionaryDetailFactory {
    public init() {}

    public func make() -> BaseViewController {
        let viewController = MonsterDictionaryDetailViewController()
        let reactor = MonsterDictionaryDetailReactor()
        viewController.reactor = reactor
        // 하단 탭바 히든
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
