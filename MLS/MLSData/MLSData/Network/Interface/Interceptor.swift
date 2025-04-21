import Foundation

import RxSwift

protocol Interceptor {
    func adapt(_ request: URLRequest) throws -> URLRequest
    
    func retry(_ request: URLRequest, response: HTTPURLResponse?, error: Error?) -> Observable<Bool>
}
 
