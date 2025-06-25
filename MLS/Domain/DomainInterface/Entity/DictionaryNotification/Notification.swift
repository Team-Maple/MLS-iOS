public struct Notification {
    public let title: String
    public let date: String
    public let isChecked: Bool

    public init(title: String, date: String, isChecked: Bool = false) {
        self.title = title
        self.date = date
        self.isChecked = isChecked
    }
}
