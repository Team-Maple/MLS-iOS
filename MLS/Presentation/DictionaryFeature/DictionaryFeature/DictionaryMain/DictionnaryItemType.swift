import UIKit

public enum DictionaryItemType {
    case item
    case monster
    case map
    case npc
    case quest
    
    var backgroundColor: UIColor {
        switch self {
        case .item:
                .listItem
        case .monster:
                .listMonster
        case .map:
                .listMap
        case .npc:
                .listNPC
        case .quest:
                .listQuest
        }
    }
}
