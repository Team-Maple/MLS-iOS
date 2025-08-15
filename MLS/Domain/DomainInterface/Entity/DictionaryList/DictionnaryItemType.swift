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
            [.normal, .dropMonster]
        case .monster:
            [.normal, .appearMap, .dropItem]
        case .map:
            [.mapInfo, .appearMonster, .appearNPC]
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
    case appearMonster
    case appearNPC
    case dropItem
    case linkedQuest
    case quest
    case dropMonster

    public var description: String {
        switch self {
        case .normal:
            return "상세 정보"
        case .mapInfo:
            return "맵 정보"
        case .appearMap:
            return "출현 맵"
        case .appearMonster:
            return "출현 몬스터"
        case .appearNPC:
            return "출현 NPC"
        case .dropItem:
            return "드롭 아이템"
        case .linkedQuest:
            return "연계 퀘스트"
        case .quest:
            return "퀘스트"
        case .dropMonster:
            return "드롭 몬스터"
        }
    }

    public var sortFilter: [SortType] {
        switch self {
        case .appearMonster:
            [.mostAppear]
        case .dropItem:
            [.mostDrop, .levelASC, .levelDESC]
        case .quest:
            [.levelLowest, .levelHighest]
        default:
            []
        }
    }
}
