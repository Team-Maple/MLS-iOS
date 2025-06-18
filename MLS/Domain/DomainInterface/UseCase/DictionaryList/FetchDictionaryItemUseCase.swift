import RxSwift

public protocol FetchDictionaryItemsUseCase {
    func execute(type: DictionaryType) -> Observable<[DictionaryItem]>
}
