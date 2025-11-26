import Foundation
import UIKit

import DomainInterface

public enum DictionaryListEndPoint {
    static let base = "https://api.mapleland.kro.kr"
    // 검색 카운트
    public static func fetchListCount(type: String, keyword: String?) -> ResponsableEndPoint<SearchCountDTO> {
        let query = ["keyword": keyword ?? ""]
        return .init(baseURL: base, path: "/api/v1/\(type)/counts", method: .GET, query: query)
    }
    // 전체 리스트
    public static func fetchAllList(keyword: String?, page: Int? = nil, size: Int? = nil) -> ResponsableEndPoint<PagedListResponseDTO<DictionaryAllDTO>> {
        let query = DictionaryListQuery(keyword: keyword ?? "", page: page ?? 0, size: size ?? 20, sort: nil)
        return .init(baseURL: base, path: "/api/v1/search", method: .GET, query: query)
    }
    // 몬스터 리스트
    public static func fetchMonsterList(keyword: String?, minLevel: Int?, maxLevel: Int?, page: Int, size: Int, sort: String?) -> ResponsableEndPoint<PagedListResponseDTO<DictionaryMonsterDTO>> {
        let query = DictionaryListQuery(keyword: keyword ?? "", page: page, size: size, sort: sort, minLevel: minLevel ?? 1, maxLevel: maxLevel ?? 200)
        return .init(baseURL: base, path: "/api/v1/monsters", method: .GET, query: query
        )
    }
    // NPC 리스트
    public static func fetchNPCList(keyword: String?, page: Int, size: Int, sort: String?) -> ResponsableEndPoint<PagedListResponseDTO<DictionaryNPCDTO>> {
        let query = DictionaryListQuery(keyword: keyword ?? "", page: page, size: size, sort: sort)
        return .init(baseURL: base, path: "/api/v1/npcs", method: .GET, query: query
        )
    }
    // 퀘스트 리스트
    public static func fetchQuestList(keyword: String?, page: Int, size: Int, sort: String?) -> ResponsableEndPoint<PagedListResponseDTO<DictionaryQuestDTO>> {
        let query = DictionaryListQuery(keyword: keyword ?? "", page: page, size: size, sort: sort)
        return .init(baseURL: base, path: "/api/v1/quests", method: .GET, query: query
        )
    }
    // 아이템 리스트
    public static func fetchItemList(
        keyword: String? = nil,
        jobId: [Int]? = nil,
        minLevel: Int? = nil,
        maxLevel: Int? = nil,
        categoryIds: [Int]? = nil,
        page: Int? = nil,
        size: Int? = nil,
        sort: String? = nil
    ) -> ResponsableEndPoint<PagedListResponseDTO<DictionaryItemDTO>> {
        let joinedCategoryIds = categoryIds?.map(String.init).joined(separator: ",")
        let joinedJobIds = jobId?.map(String.init).joined(separator: ",")

        let query = DictionaryListQuery(keyword: keyword, page: page ?? 0, size: size ?? 20, sort: sort, minLevel: minLevel ?? 1, maxLevel: maxLevel ?? 200, jobIds: joinedJobIds, categoryIds: joinedCategoryIds)
        return .init(baseURL: base, path: "/api/v1/items", method: .GET, query: query
        )
    }
    // 맵 리스트
    public static func fetchMapList(keyword: String?, page: Int, size: Int, sort: String?) -> ResponsableEndPoint<PagedListResponseDTO<DictionaryMapDTO>> {
        let query = DictionaryListQuery(keyword: keyword ?? "", page: page, size: size, sort: sort)
        return .init(baseURL: base, path: "/api/v1/maps", method: .GET, query: query)
    }
}
