import Foundation

import RxSwift

public protocol Interceptor {
    /// Request에 요소를 추가하기  위한 함수
    /// - Parameter request: 엔드포인트로 부터 만들어진 Request
    /// - Returns: 요소가 추가된 Request
    func adapt(_ request: URLRequest) -> URLRequest

    /// 필요에 따라 재요청을 하기 위한 함수
    /// - Parameters:
    ///   - request: 엔드포인트로 부터 만들어진 Request
    ///   - response: 돌려받은 응답
    ///   - error: 통신간에 발생한 에러
    /// - Returns: 재요청이 필요하면 true, 필요없으면 false
    func retry(data: Data?, response: URLResponse?, error: Error?) -> Bool
}
