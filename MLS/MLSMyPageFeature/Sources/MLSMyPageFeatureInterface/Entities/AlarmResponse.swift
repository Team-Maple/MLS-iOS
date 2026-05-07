import Foundation

public struct AlarmResponse: Equatable {
    public let id: Int
    public let type: String
    public let title: String
    public let link: String
    public let date: String

    public init(id: Int, type: String, title: String, link: String, date: String) {
        self.id = id
        self.type = type
        self.title = title
        self.link = link
        self.date = date
    }
}

public struct AllAlarmResponse: Equatable {
    public let id: Int
    public let type: String
    public let title: String
    public let link: String
    public let date: String
    public var alreadyRead: Bool

    public init(id: Int, type: String, title: String, link: String, date: String, alreadyRead: Bool) {
        self.id = id
        self.type = type
        self.title = title
        self.link = link
        self.date = date
        self.alreadyRead = alreadyRead
    }
}

public struct PagedEntity<T> {
    public let items: [T]
    public let hasMore: Bool

    public init(items: [T], hasMore: Bool) {
        self.items = items
        self.hasMore = hasMore
    }
}
