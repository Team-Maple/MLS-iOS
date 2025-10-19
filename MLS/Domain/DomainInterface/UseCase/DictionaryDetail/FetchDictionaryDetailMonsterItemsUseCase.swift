import RxSwift

public protocol FetchDictionaryDetailMonsterItemsUseCase {
    func execute(id: Int) -> Observable<[DictionaryDetailMonsterDropItemResponse]>
}
