import Foundation

import RxSwift

protocol Provider {
    func requestData<T: Decodable>(endPoint: EndPoint, interceptor: Interceptor?) -> Observable<T>

    func requestData(endPoint: EndPoint, interceptor: Interceptor?) -> Completable
}
