import RxSwift

public protocol FetchDictionaryDetailItemDropMonsterUseCase {
    func execute(id: Int, sort: String?) -> Observable<[DictionaryDetailItemDropMonsterResponse]>
}
