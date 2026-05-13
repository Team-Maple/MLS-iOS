import Foundation
import Security

public final class TokenInterceptor: Interceptor {

    public init() {}

    public func adapt(_ request: URLRequest) -> URLRequest {
        guard let token = fetchAccessToken() else { return request }
        var adapted = request
        adapted.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return adapted
    }

    public func retry(data: Data?, response: URLResponse?, error: Error?) -> Bool {
        return false
    }

    private func fetchAccessToken() -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: "keyChain",
            kSecAttrAccount: "accessToken",
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var ref: AnyObject?
        guard SecItemCopyMatching(query, &ref) == errSecSuccess,
              let data = ref as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
