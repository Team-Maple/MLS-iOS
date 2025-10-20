import RxSwift

public protocol FetchDictionaryDetailItemUseCase {
    func execute(id: Int) -> Observable<DictionaryDetailItemResponse>
}
