import BaseFeature
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryDetailFactoryImpl: DictionaryDetailFactory {
    private let dictionaryDetailMapUseCase: FetchDictionaryDetailMapUseCase
    private let dictionaryDetailMapSpawnMonsterUseCase: FetchDictionaryDetailMapSpawnMonsterUseCase
    private let dictionaryDetailMapNpcUseCase: FetchDictionaryDetailMapNpcUseCase
    private let dictionaryDetailQuestLinkedQuestsUseCase: FetchDictionaryDetailQuestLinkedQuestsUseCase
    private let dictionaryDetailQuestUseCase: FetchDictionaryDetailQuestUseCase
    private let dictionaryDetailItemDropMonsterUseCase: FetchDictionaryDetailItemDropMonsterUseCase
    private let dictionaryDetailItemUseCase: FetchDictionaryDetailItemUseCase
    private let dictionaryDetailNpcUseCase: FetchDictionaryDetailNpcUseCase
    private let dictionaryDetailNpcQuestUseCase: FetchDictionaryDetailNpcQuestUseCase
    private let dictionaryDetailNpcMapUseCase:
        FetchDictionaryDetailNpcMapUseCase
    private let dictionaryDetailMonsterUseCase: FetchDictionaryDetailMonsterUseCase
    private let dictionaryDetailMonsterDropItemUseCase: FetchDictionaryDetailMonsterItemsUseCase
    private let dictionaryDetailMonsterMapUseCase: FetchDictionaryDetailMonsterMapUseCase

    public init(dictionaryDetailMapUseCase: FetchDictionaryDetailMapUseCase, dictionaryDetailMapSpawnMonsterUseCase: FetchDictionaryDetailMapSpawnMonsterUseCase, dictionaryDetailMapNpcUseCase: FetchDictionaryDetailMapNpcUseCase, dictionaryDetailQuestLinkedQuestsUseCase: FetchDictionaryDetailQuestLinkedQuestsUseCase, dictionaryDetailQuestUseCase: FetchDictionaryDetailQuestUseCase, dictionaryDetailItemDropMonsterUseCase: FetchDictionaryDetailItemDropMonsterUseCase, dictionaryDetailItemUseCase: FetchDictionaryDetailItemUseCase, dictionaryDetailNpcUseCase: FetchDictionaryDetailNpcUseCase, dictionaryDetailNpcQuestUseCase: FetchDictionaryDetailNpcQuestUseCase, dictionaryDetailNpcMapUseCase: FetchDictionaryDetailNpcMapUseCase, dictionaryDetailMonsterUseCase: FetchDictionaryDetailMonsterUseCase, dictionaryDetailMonsterDropItemUseCase: FetchDictionaryDetailMonsterItemsUseCase, dictionaryDetailMonsterMapUseCase: FetchDictionaryDetailMonsterMapUseCase) {
        self.dictionaryDetailMapUseCase = dictionaryDetailMapUseCase
        self.dictionaryDetailMapSpawnMonsterUseCase = dictionaryDetailMapSpawnMonsterUseCase
        self.dictionaryDetailMapNpcUseCase = dictionaryDetailMapNpcUseCase
        self.dictionaryDetailQuestLinkedQuestsUseCase = dictionaryDetailQuestLinkedQuestsUseCase
        self.dictionaryDetailQuestUseCase = dictionaryDetailQuestUseCase
        self.dictionaryDetailItemDropMonsterUseCase = dictionaryDetailItemDropMonsterUseCase
        self.dictionaryDetailItemUseCase = dictionaryDetailItemUseCase
        self.dictionaryDetailNpcUseCase = dictionaryDetailNpcUseCase
        self.dictionaryDetailNpcQuestUseCase = dictionaryDetailNpcQuestUseCase
        self.dictionaryDetailNpcMapUseCase = dictionaryDetailNpcMapUseCase
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
            let reactor = ItemDictionaryDetailReactor(dictionaryDetailItemUseCase: dictionaryDetailItemUseCase, dictionaryDetailItemDropMonsterUseCase: dictionaryDetailItemDropMonsterUseCase, id: id)
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
            let reactor = MapDictionaryDetailReactor(dictionaryDetailMapUseCase: dictionaryDetailMapUseCase, dictionaryDetailMapSpawnMonsterUseCase: dictionaryDetailMapSpawnMonsterUseCase, dictionaryDetailMapNpcUseCase: dictionaryDetailMapNpcUseCase, id: id)
            viewController = MapDictionaryDetailViewController(imageUrl: "")
            if let viewController = viewController as? MapDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        case .npc:
            let reactor = NpcDictionaryDetailReactor(dictionaryDetailNpcUseCase: dictionaryDetailNpcUseCase, dictionaryDetailNpcQuestUseCase: dictionaryDetailNpcQuestUseCase, dictionaryDetailNpcMapUseCase: dictionaryDetailNpcMapUseCase, id: id)
            viewController = NpcDictionaryDetailViewController(imageUrl: "")
            if let viewController = viewController as? NpcDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        case .quest:
            viewController = QuestDictionaryDetailViewController(type: .quest)
            let reactor = QuestDictionaryDetailReactor(dictionaryDetailQuestUseCase: dictionaryDetailQuestUseCase, dictionaryDetailQuestLinkedQuestsUseCase: dictionaryDetailQuestLinkedQuestsUseCase, id: id)
            if let viewController = viewController as? QuestDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        }

        // 하단 탭바 히든
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
