import RxSwift

public protocol DictionaryListAPIRepository {
    // 전체
    func fetchAllList(keyword: String?, page: Int?) -> Observable<DictionaryMainResponse>
    // 몬스터
    func fetchMonsterList(keyword: String?, minLevel: Int?, maxLevel: Int?, page: Int, size: Int, sort: String?) -> Observable<DictionaryMainResponse>
    // Npc
    func fetchNpcList(keyword: String, page: Int, size: Int, sort: String?) -> Observable<DictionaryMainResponse>
    // Quest
    func fetchQuestList(keyword: String, page: Int, size: Int, sort: String?) -> Observable<DictionaryMainResponse>
    // Item
    func fetchItemList(keyword: String?, jobId: [Int]?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, page: Int?, size: Int?, sort: String?) -> Observable<DictionaryMainResponse>
    // Map
    func fetchMapList(keyword: String, page: Int, size: Int, sort: String?) -> Observable<DictionaryMainResponse>
    // 검색
    func fetchSearchList(keyword: String?) -> Observable<DictionaryMainResponse>
    // 검색 카운트
    func fetchSearchListCount(type: String, keyword: String?) -> Observable<SearchCountResponse>
}
