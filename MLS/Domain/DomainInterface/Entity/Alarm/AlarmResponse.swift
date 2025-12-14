import Foundation

public struct AlarmResponse: Equatable {
    public let type: String
    public let title: String
    public let link: String
    public let date: String

    public init(type: String, title: String, link: String, date: String) {
        self.type = type
        self.title = title
        self.link = link
        self.date = date
    }
}

public struct AllAlarmResponse: Equatable {
    public let type: String
    public let title: String
    public let link: String
    public let date: String
    public var alreadyRead: Bool

    public init(type: String, title: String, link: String, date: String, alreadyRead: Bool) {
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
