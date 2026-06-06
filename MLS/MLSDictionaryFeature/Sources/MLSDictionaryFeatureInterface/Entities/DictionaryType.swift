public enum DictionaryType: String, CaseIterable {
    case total
    case collection
    case item
    case monster
    case map
    case npc
    case quest

    public var title: String {
        switch self {
        case .total:
            return "전체"
        case .collection:
            return "컬렉션"
        case .monster:
            return "몬스터"
        case .item:
            return "아이템"
        case .map:
            return "맵"
        case .npc:
            return "NPC"
        case .quest:
            return "퀘스트"
        }
    }

    public var sortedFilter: [SortType] {
        switch self {
        case .item:
            return [
                .korean, .levelDESC, .levelASC
            ]
        case .monster:
            return [
                .korean, .levelDESC, .levelASC, .expDESC, .expASC
            ]
        default:
            return []
        }
    }

    public var detailTypes: [DetailType] {
        switch self {
        case .item:
            return [
                .dropMonsterWithText
            ]
        case .monster:
            return [
                .appearMapWithText, .dropItemWithText
            ]
        case .map:
            return [
                .appearMonsterWithText, .appearNPC
            ]
        case .npc:
            return [
                .quest
            ]
        default:
            return []
        }
    }

    public var isSortHidden: Bool {
        return sortedFilter.count == 0
    }

    public var bookmarkSortedFilter: [SortType] {
        switch self {
        case .total:
            return [
                .latest, .korean
            ]
        case .item:
            return [
                .korean, .levelDESC, .levelASC
            ]
        case .monster:
            return [
                .korean, .levelDESC, .levelASC, .expDESC, .expASC
            ]
        default:
            return []
        }
    }

    public var isBookmarkSortHidden: Bool {
        return bookmarkSortedFilter.count == 0
    }

    public var toItemType: DictionaryItemType? {
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
        default:
            return nil
        }
    }

    public var tabIndex: Int {
        switch self {
        case .total:
            0
        case .collection:
            0
        case .item:
            1
        case .monster:
            2
        case .map:
            3
        case .npc:
            4
        case .quest:
            5
        }
    }
}
