import Foundation

import RxSwift

final class RequestInterceptor: Interceptor {
    func adapt(_ request: URLRequest) throws -> URLRequest {
        var modified = request
        // ex) Bearer 토큰 추가
        if modified.value(forHTTPHeaderField: "Authorization") == nil {
            modified.setValue("Bearer token", forHTTPHeaderField: "토큰값")
        }
        return modified
    }

    func retry(_ request: URLRequest, response: HTTPURLResponse?, error: Error?) -> Observable<Bool> {
        // ex) 인증실패 -> 잘못된 토큰? -> 토큰 재발행
        if let response, response.statusCode == 401 {
            return Observable.just(true).delay(.seconds(1), scheduler: MainScheduler.instance)
        }
        return Observable.just(false)
    }
}
