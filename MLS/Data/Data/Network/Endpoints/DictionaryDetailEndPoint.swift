import Foundation
import UIKit

import DomainInterface

public enum DictionaryDetailEndPoint {
    static let base = "https://api.mapleland.kro.kr"

    // 몬스터 디테일 상세정보
    public static func fetchMonsterDetail(id: Int) -> ResponsableEndPoint<DictionaryDetailMonsterResponseDTO> {
        return .init(baseURL: base, path: "/api/v1/monsters/\(id)", method: .GET)
    }

    // 몬스터 디테일 드롭아이템
    public static func fetchMonsterDetailDropItem(id: Int, query: Encodable) -> ResponsableEndPoint<[DictionaryDetailMonsterDropItemResponseDTO]> {
        return .init(baseURL: base, path: "/api/v1/monsters/\(id)/items", method: .GET, query: query)
    }

    // 몬스터 디테일 출현맵
    public static func fetchMonsterDetailMap(id: Int) -> ResponsableEndPoint<[DictionaryDetailMonsterMapResponseDTO]> {
        return .init(baseURL: base, path: "/api/v1/monsters/\(id)/maps", method: .GET)
    }

    // Npc 디테일 상세정보
    public static func fetchNpcDetail(id: Int) -> ResponsableEndPoint<DictionaryDetailNpcResponseDTO> {
        return .init(baseURL: base, path: "/api/v1/npcs/\(id)", method: .GET)
    }
    // Npc 디테일 퀘스트
    public static func fetchNpcDetailQuest(id: Int, query: Encodable) -> ResponsableEndPoint<[DictionaryDetailNpcQuestResponseDTO]> {
        return .init(baseURL: base, path: "/api/v1/npcs/\(id)/quests", method: .GET, query: query)
    }
    // NPC 디테일 맵
    public static func fetchNpcDetailMap(id: Int) -> ResponsableEndPoint<[DictionaryDetailMonsterMapResponseDTO]> {
        return .init(baseURL: base, path: "/api/v1/npcs/\(id)/maps", method: .GET)
    }
    // Item 디테일 상세정보
    public static func fetchItemDetail(id: Int) -> ResponsableEndPoint<DictionaryDetailItemResponseDTO> {
        return .init(baseURL: base, path: "/api/v1/items/\(id)", method: .GET)
    }
    // Item 디테일 드롭몬스터 상세정보
    public static func fetchItemDetailDropMonster(id: Int, query: Encodable) -> ResponsableEndPoint<[DictionaryDetailItemDropMonsterResponseDTO]> {
        return .init(baseURL: base, path: "/api/v1/items/\(id)/monsters", method: .GET, query: query)
    }

    // Quest 디테일 상세정보
    public static func fetchQuestDetail(id: Int) -> ResponsableEndPoint<DictionaryDetailQuestResponseDTO> {
        return .init(baseURL: base, path: "/api/v1/quests/\(id)", method: .GET)
    }

    // Quest 디테일 연계퀘스트
    public static func fetchQuestDetailLinkedQuests(id: Int) -> ResponsableEndPoint<DictionaryDetailQuestLinkedQuestsResponseDTO> {
        return .init(baseURL: base, path: "/api/v1/quests/\(id)/chain", method: .GET)
    }

    // Map 디테일 상세정보
    public static func fetchMapDetail(id: Int) -> ResponsableEndPoint<DictionaryDetailMapResponseDTO> {
        return .init(baseURL: base, path: "/api/v1/maps/\(id)", method: .GET)
    }

    // Map 디테일 출현 몬스터
    public static func fetchMapDetailSpawnMonster(id: Int, query: Encodable) -> ResponsableEndPoint<[DictionaryDetailMapSpawnMonsterResponseDTO]> {
        return .init(baseURL: base, path: "/api/v1/maps/\(id)/monsters", method: .GET, query: query)
    }

    // Map 디테일 출현 npc
    public static func fetchMapDetailNpc(id: Int) -> ResponsableEndPoint<[DictionaryDetailMapNpcResponseDTO]> {
        return .init(baseURL: base, path: "/api/v1/maps/\(id)/npcs", method: .GET)
    }
}
