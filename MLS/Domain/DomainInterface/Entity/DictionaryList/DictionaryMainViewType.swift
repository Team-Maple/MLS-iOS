public enum DictionaryMainViewType {
    case main
    case search
    case bookmark

    public var pageTabList: [DictionaryType] {
        switch self {
        case .main:
            return [.total, .monster, .item, .map, .npc, .quest]
        case .search:
            return [.total, .monster, .item, .map, .npc, .quest]
        case .bookmark:
            return [.total, .collection, .monster, .item, .map, .npc, .quest]
        }
    }
}
