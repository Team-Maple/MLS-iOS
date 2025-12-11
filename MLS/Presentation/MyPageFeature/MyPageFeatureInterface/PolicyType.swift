import Foundation

public enum PolicyType: CaseIterable {
    case service
    case privacy

    public var title: String {
        switch self {
        case .service:
            "서비스 이용약관"
        case .privacy:
            "개인정보 처리방침"
        }
    }

    public var fileName: String {
        switch self {
        case .service:
            return "TermsOfService.txt"
        case .privacy:
            return "PrivacyPolicy.txt"
        }
    }

    public var content: String {
        var result = ""
        guard let pahts = Bundle.main.path(forResource: fileName, ofType: nil) else { return "" }
        do {
            result = try String(contentsOfFile: pahts, encoding: .utf8)
            return result
        } catch {
            return "Error: file read failed - \(error.localizedDescription)"
        }
    }
}
