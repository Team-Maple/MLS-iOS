import UIKit

public enum DictionaryItemType: String {
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

    public var detailTitle: String {
        switch self {
        case .item:
            "아이템 상세 정보"
        case .monster:
            "몬스터 상세 정보"
        case .map:
            "맵 상세 정보"
        case .npc:
            "NPC 상세 정보"
        case .quest:
            "퀘스트 상세 정보"
        }
    }

    public var toDictionaryType: DictionaryType? {
        switch self {
        case .item:
            return .item
        case .monster:
            return .monster
        case .map:
            return .map
        case .npc:
            return .npc
        case .quest:
            return .quest
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
