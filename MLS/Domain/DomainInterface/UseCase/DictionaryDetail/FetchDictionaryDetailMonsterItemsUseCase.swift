import RxSwift

public protocol FetchDictionaryDetailMonsterItemsUseCase {
    func execute(id: Int, sort: String?) -> Observable<[DictionaryDetailMonsterDropItemResponse]>
}
