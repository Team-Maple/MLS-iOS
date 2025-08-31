import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryDetailFactoryImpl: DictionaryDetailFactory {
    public init() {}

    public func make(type: DictionaryType) -> BaseViewController {
        var viewController = BaseViewController()
        switch type {
        case .total:
            break
        case .collection:
            break
        case .item:
            break
        case .monster:
            viewController = MonsterDictionaryDetailViewController()
            let reactor = MonsterDictionaryDetailReactor()
            if let viewController = viewController as? MonsterDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        case .map:
            let reactor = MapDictionaryDetailReactor()
            viewController = MapDictionaryDetailViewController(reactor: reactor, imageUrl: "")
        case .npc:
            break
        case .quest:
            break
        }

        // 하단 탭바 히든
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
