import Foundation

import DomainInterface

/// 응답값이 없는 엔드포인트
public struct EndPoint: Requestable {
    public var baseURL: String
    public var path: String
    public var method: HTTPMethod
    public var query: Encodable?
    public var headers: [String: String]?
    public var body: Encodable?

    public init(
        baseURL: String,
        path: String,
        method: HTTPMethod,
        query: Encodable? = nil,
        headers: [String: String]? = nil,
        body: Encodable? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.query = query
        self.headers = headers
        self.body = body
    }
}
