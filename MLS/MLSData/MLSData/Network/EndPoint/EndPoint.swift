import Foundation

/// 응답값이 없는 엔드포인트
struct EndPoint: Requestable {
    var baseURL: String
    var path: String
    var method: HTTPMethod
    var query: (any Encodable)?
    var headers: [String: String]?
    var body: (any Encodable)?

    init(baseURL: String, path: String, method: HTTPMethod, query: (any Encodable)? = nil, headers: [String: String]? = nil, body: (any Encodable)? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.query = query
        self.headers = headers
        self.body = body
    }
}
