import Foundation
import RxSwift

protocol Provider {
    func requestData<T: Responsable & Requestable>(endPoint: T, interceptor: Interceptor?) -> Observable<T.Response>

    func requestData(endPoint: Requestable, interceptor: Interceptor?) -> Completable
}
