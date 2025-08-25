import Foundation

import RxSwift

public protocol NetworkProvider {
    ///  엔드포인트를 이용하여 응답이 있는 통신을 위한 함수
    /// - Parameters:
    ///   - endPoint: 목적지에 대한 정보를 담고있는 엔드포인트 객체
    ///   - interceptor: Request에 필요한 인터셉터
    /// - Returns: 응답값을 포함한 Response
    func requestData<T: Responsable & Requestable>(endPoint: T, interceptor: Interceptor?) -> Observable<T.Response>

    ///  엔드포인트를 이용하여 응답이 없는 통신을 위한 함수
    /// - Parameters:
    ///   - endPoint: 목적지에 대한 정보를 담고있는 엔드포인트 객체
    ///   - interceptor: Request에 필요한 인터셉터
    /// - Returns: 통신이 완료되었는지만 확인 가능
    func requestData(endPoint: Requestable, interceptor: Interceptor?) -> Completable
}
