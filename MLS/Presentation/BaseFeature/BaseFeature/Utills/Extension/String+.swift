import Foundation

extension String {
    public func isOnlyKorean() -> Bool {
        return !self.contains { char in
            guard let scalar = char.unicodeScalars.first else { return false }
            return (0x3131...0x3163).contains(scalar.value)
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
