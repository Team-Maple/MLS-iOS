import RxSwift

public protocol FetchDictionaryDetailNpcMapUseCase {
    func execute(id: Int) -> Observable<[DictionaryDetailMonsterMapResponse]>
}
