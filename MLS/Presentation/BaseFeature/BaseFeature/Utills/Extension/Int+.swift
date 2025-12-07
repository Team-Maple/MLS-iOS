import Foundation

extension Array where Element == Int {
    public func changeKoreanDate() -> String {
        return "\(self[0])년 \(self[1])월 \(self[2])일 \(self[3]):\(String(format: "%02d", self[4]))"
    }
}

extension Int {
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
