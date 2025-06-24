import Foundation

import DomainInterface

import RxRelay
import RxSwift

public final class DictionaryListRepositoryImpl: DictionaryListRepository {
    public let itemsRelay: BehaviorRelay<[DictionaryItem]>

    public init(allItems: [DictionaryItem]) {
        self.itemsRelay = BehaviorRelay(value: allItems)
        print("Repository instance: \(ObjectIdentifier(self))")
    }

    public func observeItems(type: DictionaryType) -> Observable<[DictionaryItem]> {
        return itemsRelay
            .map { items in
                guard let targetType = type.toItemType else {
                    return items
                }
                return items.filter { $0.type == targetType }
            }
    }

    public func toggleBookmark(id: String) -> Observable<[DictionaryItem]> {
        var items = itemsRelay.value
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return .just(items)
        }

        items[index].isBookmarked.toggle()
        itemsRelay.accept(items)

        return itemsRelay.asObservable()
    }
}
