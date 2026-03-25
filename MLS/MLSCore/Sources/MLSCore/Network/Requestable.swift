import Foundation

public protocol Requestable {
    var baseURL: String { get set }
    var path: String { get set }
    var method: HTTPMethod { get set }
    var query: Encodable? { get set }
    var headers: [String: String]? { get set }
    var body: Encodable? { get set }
}

extension Requestable {
    /// 엔드포인트 객체의 속성들을 이용하여 Request를 만드는 함수
    /// - Returns: API 통신에 필요한 요청 -> Request
    public func getUrlRequest() throws -> URLRequest {
        guard var base = URL(string: baseURL) else {
            throw URLError(.badURL)
        }

        base.appendPathComponent(path)

        guard var components = URLComponents(url: base, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }

        if let query = query {
            let queryData = try JSONEncoder().encode(query)
            let dictionary = try JSONSerialization.jsonObject(with: queryData, options: []) as? [String: Any]
            components.queryItems = dictionary?.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}
