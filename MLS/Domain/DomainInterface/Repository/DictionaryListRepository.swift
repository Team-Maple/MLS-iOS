import RxSwift
import RxRelay

public protocol DictionaryListRepository {
    var itemsRelay: BehaviorRelay<[DictionaryItem]> { get }

    func observeItems(type: DictionaryType) -> Observable<[DictionaryItem]>
    
    func toggleBookmark(id: String) -> Observable<[DictionaryItem]>
}
