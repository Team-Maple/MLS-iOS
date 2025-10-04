import RxSwift

public protocol FetchDictionaryDetailMonsterMapUseCase {
    func execute(id: Int) -> Observable<[DictionaryDetailMonsterMapResponse]>
}
