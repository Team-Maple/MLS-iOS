public enum DictionaryType {
    case total
    case item
    case monster
    case map
    case npc
    case quest
    case search
    
    var isFilterHidden: Bool {
        switch self {
        case .item, .monster, .search:
            false
        default:
            true
        }
    }
}
