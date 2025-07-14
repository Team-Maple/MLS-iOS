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

    public var isFilterHidden: Bool {
        return sortedFilter.count == 0
    }

    public var sortedFilter: [String] {
        switch self {
        case .item:
            return [
                "가나다 순", "레벨 높은 순", "레벨 낮은 순"
            ]
        case .monster:
            return [
                "가나다 순", "레벨 높은 순", "레벨 낮은 순", "획득 경험치 높은 순", "획득 경험치 낮은 순"
            ]
        default:
            return []
        }
    }
    
    public var bookmarkSortedFilter: [String] {
        switch self {
        case .collection:
            return [
                "최신순", "가나다 순"
            ]
        case .item:
            return [
                "가나다 순", "레벨 높은 순", "레벨 낮은 순"
            ]
        case .monster:
            return [
                "가나다 순", "레벨 높은 순", "레벨 낮은 순", "획득 경험치 높은 순", "획득 경험치 낮은 순"
            ]
        default:
            return []
        }
    }


    public var toItemType: DictionaryItemType? {
        switch self {
        case .total:
            return nil
        case .collection:
            return nil
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
