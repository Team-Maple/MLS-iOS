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
            viewController = ItemDictionaryDetailViewController()
            let reactor = ItemDictionaryDetailReactor()
            if let viewController = viewController as? ItemDictionaryDetailViewController {
                viewController.reactor = reactor
            }
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
            viewController = QuestDictionaryDetailViewController()
            let reactor = QuestDictionaryDetailReactor()
            if let viewController = viewController as? QuestDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        }

        // 하단 탭바 히든
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
