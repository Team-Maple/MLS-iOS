import Foundation

extension String {
    public func isOnlyKorean() -> Bool {
        return !self.isEmpty && self.allSatisfy { char in
            guard let scalar = char.unicodeScalars.first else { return false }
            return !(0xAC00...0xD7A3).contains(scalar.value)
        }
    }

    public func toDisplayDateString() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "ko_KR")
        inputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        guard let date = inputFormatter.date(from: self) else { return self }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "yyyy.MM.dd HH:mm"

        return outputFormatter.string(from: date)
    }
}
