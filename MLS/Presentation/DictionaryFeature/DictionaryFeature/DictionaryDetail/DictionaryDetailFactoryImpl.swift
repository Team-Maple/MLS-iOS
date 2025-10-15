import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryDetailFactoryImpl: DictionaryDetailFactory {
    private let dictionaryDetailMonsterUseCase: FetchDictionaryDetailMonsterUseCase
    private let dictionaryDetailMonsterDropItemUseCase: FetchDictionaryDetailMonsterItemsUseCase
    private let dictionaryDetailMonsterMapUseCase: FetchDictionaryDetailMonsterMapUseCase
    
    public init(dictionaryDetailMonsterUseCase: FetchDictionaryDetailMonsterUseCase, dictionaryDetailMonsterDropItemUseCase: FetchDictionaryDetailMonsterItemsUseCase, dictionaryDetailMonsterMapUseCase: FetchDictionaryDetailMonsterMapUseCase) {
        self.dictionaryDetailMonsterUseCase = dictionaryDetailMonsterUseCase
        self.dictionaryDetailMonsterDropItemUseCase = dictionaryDetailMonsterDropItemUseCase
        self.dictionaryDetailMonsterMapUseCase = dictionaryDetailMonsterMapUseCase 
    }

    public func make(type: DictionaryType, id: Int) -> BaseViewController {
        var viewController = BaseViewController()
        switch type {
        case .total:
            break
        case .collection:
            break
        case .item:
            viewController = ItemDictionaryDetailViewController(type: .item)
            let reactor = ItemDictionaryDetailReactor()
            if let viewController = viewController as? ItemDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        case .monster:
            viewController = MonsterDictionaryDetailViewController(type: .monster)
            let reactor = MonsterDictionaryDetailReactor(dictionaryDetailMonsterUseCase: dictionaryDetailMonsterUseCase, dictionaryDetailMonsterDropItemUseCase: dictionaryDetailMonsterDropItemUseCase, dictionaryDetailMonsterMapUseCase: dictionaryDetailMonsterMapUseCase, id: id)
            if let viewController = viewController as? MonsterDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        case .map:
            let reactor = MapDictionaryDetailReactor()
            viewController = MapDictionaryDetailViewController(imageUrl: "")
            if let viewController = viewController as? MapDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        case .npc:
            let reactor = NpcDictionaryDetailReactor()
            viewController = NpcDictionaryDetailViewController(imageUrl: "")
            if let viewController = viewController as? NpcDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        case .quest:
            viewController = QuestDictionaryDetailViewController(type: .quest)
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
