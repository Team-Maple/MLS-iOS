public enum DictionaryType: CaseIterable {
    case total
    case item
    case monster
    case map
    case npc
    case quest

    public var title: String {
        switch self {
        case .total:
            return "전체"
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
        switch self {
        case .item, .monster:
            false
        default:
            true
        }
    }

    public var toItemType: DictionaryItemType? {
        switch self {
        case .total:
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
