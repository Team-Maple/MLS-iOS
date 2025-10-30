import UIKit

import DomainInterface

public struct BookmarkCollection: Equatable {
    public var id: Int
    public var title: String
    public var count: Int {
        return items.count
    }

    public var items: [DictionaryItem]
    public var thumbnails: [UIImage] {
        Array(items.prefix(4).map { $0.image })
    }

    public init(id: Int, title: String, items: [DictionaryItem]) {
        self.id = id
        self.title = title
        self.items = items
    }
}
