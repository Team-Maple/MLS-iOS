public enum DictionaryType: CaseIterable {
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

    public var detailSortedFilter: [SortType] {
        switch self {
        case .item, .monster:
            return [
                .mostDrop, .levelDESC, .levelASC
            ]
        case .map:
            return [
                .mostAppear
            ]
        case .npc:
            return [
                .levelLowest, .levelHighest
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
}
