import Foundation

import DomainInterface

import RxSwift

public class TokenInterceptor: Interceptor {
    public init() {}
    public func adapt(_ request: URLRequest) -> URLRequest {
        return request
    }
    
    public func retry(data: Data?, response: URLResponse?, error: Error?) -> Bool {
        return false
    }
}
