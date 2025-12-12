import RxSwift

public protocol FetchDictionaryDetailMapSpawnMonsterUseCase {
    func execute(id: Int, sort: String?) -> Observable<[DictionaryDetailMapSpawnMonsterResponse]>
}
