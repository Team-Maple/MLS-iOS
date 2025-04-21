import Foundation

import RxSwift

protocol Provider {
    func requestData<T: Codable>(endPoint: EndPoint, interceptor: Interceptor?) -> Observable<T>
}
