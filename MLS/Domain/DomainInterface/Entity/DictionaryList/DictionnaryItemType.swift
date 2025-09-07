import UIKit

public enum DictionaryItemType {
    case item
    case monster
    case map
    case npc
    case quest

    public var detailTypes: [DetailType] {
        switch self {
        case .item:
            [.normal, .dropMonsterWithText]
        case .monster:
            [.normal, .appearMapWithText, .dropItemWithText]
        case .map:
            [.mapInfo, .appearMonsterWithText, .appearNPC]
        case .npc:
            [.appearMap, .quest]
        case .quest:
            [.normal, .linkedQuest]
        }
    }
}

public enum DetailType {
    case normal
    case mapInfo
    case appearMap
    case appearNPC
    case linkedQuest
    case quest
    case dropItemWithText
    case appearMapWithText
    case appearMonsterWithText
    case dropMonsterWithText

    public var description: String {
        switch self {
        case .normal:
            return "상세 정보"
        case .mapInfo:
            return "맵 정보"
        case .appearNPC:
            return "출현 NPC"
        case .linkedQuest:
            return "연계 퀘스트"
        case .quest:
            return "퀘스트"
        case .appearMap, .appearMapWithText:
            return "출현 맵"
        case .dropItemWithText:
            return "드롭 아이템"
        case .appearMonsterWithText:
            return "출현 몬스터"
        case .dropMonsterWithText:
            return "드롭 몬스터"
        }
    }

    public var sortFilter: [SortType] {
        switch self {
        case .appearMonsterWithText, .appearMapWithText:
            [.mostAppear]
        case .dropItemWithText, .dropMonsterWithText:
            [.mostDrop, .levelASC, .levelDESC]
        case .quest:
            [.levelLowest, .levelHighest]
        default:
            []
        }
    }
    
    
}
