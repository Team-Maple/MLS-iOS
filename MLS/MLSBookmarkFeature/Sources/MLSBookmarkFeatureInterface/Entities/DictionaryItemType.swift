public enum DictionaryItemType: String {
    case item
    case monster
    case map
    case npc
    case quest

    public var toDictionaryType: DictionaryType? {
        switch self {
        case .item: return .item
        case .monster: return .monster
        case .map: return .map
        case .npc: return .npc
        case .quest: return .quest
        }
    }
}
