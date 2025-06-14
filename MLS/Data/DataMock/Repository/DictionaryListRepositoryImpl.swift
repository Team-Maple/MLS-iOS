import Foundation

import DomainInterface

import RxSwift
import RxRelay

public final class DictionaryListRepositoryImpl: DictionaryListRepository {
    
    // MARK: - Properties
    
    private let itemsRelay: BehaviorRelay<[DictionaryItem]> = .init(value: [])
    
    public var items: Observable<[DictionaryItem]> {
        return itemsRelay.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    private var allItems: [DictionaryItem] = []
    
    public init(allItems: [DictionaryItem]) {
        self.allItems = allItems
        self.itemsRelay.accept(allItems)
    }
}

// MARK: - Methods
extension DictionaryListRepositoryImpl {
    public func fetchItems(type: DictionaryType) -> Observable<[DictionaryItem]> {
        return itemsRelay
            .map { items in
                guard let itemType = type.toItemType else {
                    return items
                }
                return items.filter { $0.type == itemType }
            }
            .distinctUntilChanged()
    }

    public func toggleBookmark(id: String) -> Observable<[DictionaryItem]> {
        if let index = allItems.firstIndex(where: { $0.id == id }) {
            var item = allItems[index]
            item.isBookmarked.toggle()
            allItems[index] = item
            itemsRelay.accept(allItems)
        }

        return Observable.just(allItems)
    }
}
