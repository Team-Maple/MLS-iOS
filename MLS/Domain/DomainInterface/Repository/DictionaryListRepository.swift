import RxSwift

public protocol DictionaryListRepository {
    var items: Observable<[DictionaryItem]> { get }

    func fetchItems(type: DictionaryType) -> Observable<[DictionaryItem]>
    
    func toggleBookmark(id: String) -> Observable<[DictionaryItem]>
}
