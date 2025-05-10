import Foundation

import DomainInterface

/// 응답값이 없는 엔드포인트
public struct EndPoint: Requestable {
    public var baseURL: String
    public var path: String
    public var method: HTTPMethod
    public var query: (any Encodable)?
    public var headers: [String: String]?
    public var body: (any Encodable)?

    public init(
        baseURL: String,
        path: String,
        method: HTTPMethod,
        query: (any Encodable)? = nil,
        headers: [String: String]? = nil,
        body: (any Encodable)? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.query = query
        self.headers = headers
        self.body = body
    }
}
