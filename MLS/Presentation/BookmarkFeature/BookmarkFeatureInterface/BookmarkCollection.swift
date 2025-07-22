import UIKit

import DomainInterface

public struct BookmarkCollection {
    public var title: String
    public var count: Int {
        return items.count
    }

    public var items: [DictionaryItem]
    public var thumbnails: [UIImage] {
        Array(items.prefix(4).map { $0.image })
    }
    
    public init(title: String, items: [DictionaryItem]) {
        self.title = title
        self.items = items
    }
}
