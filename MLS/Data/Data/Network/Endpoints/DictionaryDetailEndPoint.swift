import Foundation
import UIKit

import DomainInterface

public enum DictionaryDetailEndPoint {
    static let base = "https://api.mapleland.kro.kr"
    
    // 몬스터 디테일 상세정보
    public static func fetchMonsterDetail(id: Int) -> ResponsableEndPoint<DictionaryDetailMonsterResponse> {
        return .init(baseURL: base, path: "/api/v1/monsters/\(id)", method: .GET)
    }
    
    // 몬스터 디테일 드롭아이템
    public static func fetchMonsterDetailDropItem(id: Int) -> ResponsableEndPoint<[DictionaryDetailMonsterDropItemResponse]> {
        return .init(baseURL: base, path: "/api/v1/monsters/\(id)/items", method: .GET)
    }
    
    // 몬스터 디테일 출현맵
    public static func fetchMonsterDetailMap(id: Int) -> ResponsableEndPoint<[DictionaryDetailMonsterMapResponse]> {
        return .init(baseURL: base, path: "/api/v1/monsters/\(id)/maps", method: .GET)
    }
}
