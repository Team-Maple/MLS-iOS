import RxSwift

public protocol FetchDictionaryDetailMonsterUseCase {
    func execute(id: Int) -> Observable<DictionaryDetailMonsterResponse>
}
