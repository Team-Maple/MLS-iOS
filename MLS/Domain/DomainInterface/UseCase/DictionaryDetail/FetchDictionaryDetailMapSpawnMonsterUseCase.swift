import RxSwift

public protocol FetchDictionaryDetailMapSpawnMonsterUseCase {
    func execute(id: Int) -> Observable<[DictionaryDetailMapSpawnMonsterResponse]>
}
