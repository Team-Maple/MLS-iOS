import Foundation

import DomainInterface

import RxSwift

public class TokenInterceptor: Interceptor {
    public init() {}
    public func adapt(_ request: URLRequest) -> URLRequest {
        var request = request
//        request.setValue("Content-Type", forHTTPHeaderField: "application/json")
        return request
    }
    
    public func retry(_ request: URLRequest, response: HTTPURLResponse?, error: (any Error)?) -> Observable<Bool> {
        return .just(false)
    }
}
