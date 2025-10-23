import UIKit

public struct DictionaryItem: Equatable {
    public let id: Int
    public let type: DictionaryItemType
    public let mainText: String
    public let subText: String
    public let image: UIImage
    public var isBookmarked: Bool

    public static func == (lhs: DictionaryItem, rhs: DictionaryItem) -> Bool {
        return lhs.id == rhs.id &&
            lhs.type == rhs.type &&
            lhs.mainText == rhs.mainText &&
            lhs.subText == rhs.subText &&
            lhs.image == rhs.image &&
            lhs.isBookmarked == rhs.isBookmarked
    }

    public init(id: Int, type: DictionaryItemType, mainText: String, subText: String, image: UIImage, isBookmarked: Bool) {
        self.id = id
        self.type = type
        self.mainText = mainText
        self.subText = subText
        self.image = image
        self.isBookmarked = isBookmarked
    }
}
