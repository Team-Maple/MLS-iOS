import RxSwift

public protocol DictionaryDetailAPIRepository {
    // 몬스터 디테일 상세정보
    func fetchMonsterDetail(id: Int) -> Observable<DictionaryDetailMonsterResponse>
    // 몬스터 디테일 드롭 아이템
    func fetchMonsterDetailDropItem(id: Int, sort: String?) -> Observable<[DictionaryDetailMonsterDropItemResponse]>
    // 몬스터 디테일 출현맵
    func fetchMonsterDetailMap(id: Int) -> Observable<[DictionaryDetailMonsterMapResponse]>

    // Npc 디테일 상세정보
    func fetchNpcDetail(id: Int) -> Observable<DictionaryDetailNpcResponse>

    // NPC 디테일 퀘스트
    func fetchNpcDetailQuest(id: Int, sort: String?) -> Observable<[DictionaryDetailNpcQuestResponse]>
    // NPC 디테일 맵
    func fetchNpcDetailMap(id: Int) -> Observable<[DictionaryDetailMonsterMapResponse]>
    // Item 디테일 상세정보
    func fetchItemDetail(id: Int) -> Observable<DictionaryDetailItemResponse>
    // Item 디테일 드롭 몬스터
    func fetchItemDetailDropMonster(id: Int, sort: String?) -> Observable<[DictionaryDetailItemDropMonsterResponse]>
    // Quest 디테일 상세정보
    func fetchQuestDetail(id: Int) -> Observable<DictionaryDetailQuestResponse>
    // Quest 연계 퀘스트 상세정보
    func fetchQuestDetailLinkedQuestsDetail(id: Int) -> Observable<DictionaryDetailQuestLinkedQuestsResponse>
    // Map 디테일 상세정보
    func fetchMapDetail(id: Int) -> Observable<DictionaryDetailMapResponse>
    // Map 디테일 출현 몬스터 정보
    func fetchMapDetailSpawnMonster(id: Int, sort: String?) -> Observable<[DictionaryDetailMapSpawnMonsterResponse]>
    // Map 디테일 출현 Npc 정보
    func fetchMapDetailNpc(id: Int) -> Observable<[DictionaryDetailMapNpcResponse]>
}
