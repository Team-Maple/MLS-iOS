import Foundation

public extension String {
    func isOnlyKorean() -> Bool {
        return !self.isEmpty &&
            self.allSatisfy { char in
                char.unicodeScalars.allSatisfy { scalar in
                    switch scalar.value {
                    case 0x30...0x39:
                        return true
                    case 0xac00...0xd7a3:
                        return true
                    case 0x3131...0x3163:
                        return true
                    default:
                        return false
                    }
                }
            }
    }

    func toDisplayDateString() -> String {
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
