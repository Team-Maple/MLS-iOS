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
        case .total: return "전체"
        case .collection: return "컬렉션"
        case .item: return "아이템"
        case .monster: return "몬스터"
        case .map: return "맵"
        case .npc: return "NPC"
        case .quest: return "퀘스트"
        }
    }

    public var bookmarkSortedFilter: [SortType] {
        switch self {
        case .total: return [.korean, .latest]
        case .item: return [.korean, .levelDESC, .levelASC]
        case .monster: return [.korean, .levelDESC, .levelASC]
        case .map: return [.korean, .mostAppear]
        case .npc: return [.korean]
        case .quest: return [.korean, .levelLowest, .levelHighest]
        case .collection: return []
        }
    }

    public var isBookmarkSortHidden: Bool {
        return bookmarkSortedFilter.count == 0
    }

    public var tabIndex: Int {
        switch self {
        case .total: return 0
        case .collection: return 1
        case .monster: return 2
        case .item: return 3
        case .map: return 4
        case .npc: return 5
        case .quest: return 6
        }
    }
}
