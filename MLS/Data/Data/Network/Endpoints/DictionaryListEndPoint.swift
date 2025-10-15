import Foundation
import UIKit

import DomainInterface

public enum DictionaryListEndPoint {
    static let base = "https://api.mapleland.kro.kr"
    // 몬스터 리스트
    public static func fetchMonsterList(keyword: String?, minLevel: Int?, maxLevel: Int?, page: Int, size: Int, sort: String?) -> ResponsableEndPoint<DictionaryMonsterListResponseDTO> {
        let query = DictionaryListQuery(keyword: keyword ?? "", page: page, size: size, sort: sort, minLevel: minLevel ?? 1, maxLevel: maxLevel ?? 200)
        return .init(baseURL: base, path: "/api/v1/monsters", method: .GET, query: query
        )
    }
    // NPC 리스트
    public static func fetchNPCList(keyword: String?, page: Int, size: Int, sort: String?) -> ResponsableEndPoint<DictionaryNPCListResponseDTO> {
        let query = DictionaryListQuery(keyword: keyword ?? "", page: page, size: size, sort: sort)
        return .init(baseURL: base, path: "/api/v1/npcs", method: .GET, query: query
        )
    }
    // 퀘스트 리스트
    public static func fetchQuestList(keyword: String?, page: Int, size: Int, sort: String?) -> ResponsableEndPoint<DictionaryQuestListResponseDTO> {
        let query = DictionaryListQuery(keyword: keyword ?? "", page: page, size: size, sort: sort)
        return .init(baseURL: base, path: "/api/v1/quests", method: .GET, query: query
        )
    }
    // 아이템 리스트
    public static func fetchItemList(keyword: String? = nil, jobId: Int? = nil, minLevel: Int? = nil, maxLevel: Int? = nil, categoryIds: [Int]? = nil, page: Int? = nil, size: Int? = nil, sort: String? = nil) -> ResponsableEndPoint<DictionaryItemListResponseDTO> {
        let query = DictionaryListQuery(keyword: keyword, page: page ?? 0, size: size ?? 20, sort: sort, minLevel: minLevel, maxLevel: maxLevel, jobId: jobId)
        return .init(baseURL: base, path: "/api/v1/items", method: .GET, query: query
        )
    }
    // 맵 리스트
    public static func fetchMapList(keyword: String?, page: Int, size: Int, sort: String?) -> ResponsableEndPoint<DictionaryMapListResponseDTO> {
        let query = DictionaryListQuery(keyword: keyword ?? "", page: page, size: size, sort: sort)
        return .init(baseURL: base, path: "/api/v1/maps", method: .GET, query: query)
    }
    // 북마크 추가
    public static func postBookmark(bookmarkType: String, resourceId: Int) -> ResponsableEndPoint<BookmarkResponseDTO> {
        let body = BookmarkRequestBody(bookmarkType: bookmarkType, resourceId: resourceId)
        return .init(baseURL: base, path: "/api/v1/bookmarks", method: .POST, body: body)
    }
}
