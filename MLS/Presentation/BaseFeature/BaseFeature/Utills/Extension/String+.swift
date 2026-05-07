import Foundation

extension String {
    public func isOnlyKorean() -> Bool {
        return !self.contains { char in
            guard let scalar = char.unicodeScalars.first else { return false }
            return (0x3131 ... 0x3163).contains(scalar.value)
        }
    }

    private static let inputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter

    }()

    private static let outputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter
    }()

    public func toDisplayDateString() -> String {
        guard let date = Self.inputDateFormatter.date(from: self) else {
            return self
        }
        return Self.outputDateFormatter.string(from: date)
    }
}
