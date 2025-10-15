import RxSwift

public protocol DictionaryDetailAPIRepository {
    // 몬스터 디테일 상세정보
    func fetchMonsterDetail(id: Int) -> Observable<DictionaryDetailMonsterResponse>
    // 몬스터 디테일 드롭 아이템
    func fetchMonsterDetailDropItem(id: Int) -> Observable<[DictionaryDetailMonsterDropItemResponse]>
    // 몬스터 디테일 출현맵
    func fetchMonsterDetailMap(id: Int) -> Observable<[DictionaryDetailMonsterMapResponse]>
}
