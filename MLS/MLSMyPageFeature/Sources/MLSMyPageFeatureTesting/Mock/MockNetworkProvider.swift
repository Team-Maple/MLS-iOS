import MLSCore

import RxSwift

public final class MockNetworkProvider: NetworkProvider {

    public init() {}

    public var requestWithResponseCalled = false
    public var requestCompletableCalled = false

    public var receivedInterceptor: Interceptor?
    public var receivedEndPoint: Any?

    public var responseResult: Any?
    public var responseError: Error?

    public var completableResult: Completable = .empty()

    public func requestData<T: Responsable & Requestable>(
        endPoint: T,
        interceptor: Interceptor?
    ) -> Observable<T.Response> {

        requestWithResponseCalled = true
        receivedEndPoint = endPoint
        receivedInterceptor = interceptor

        if let error = responseError {
            return .error(error)
        }

        guard let result = responseResult as? T.Response else {
            fatalError("MockNetworkProvider.responseResult 타입이 \(T.Response.self) 와 일치하지 않습니다.")
        }

        return .just(result)
    }

    public func requestData(
        endPoint: Requestable,
        interceptor: Interceptor?
    ) -> Completable {

        requestCompletableCalled = true
        receivedEndPoint = endPoint
        receivedInterceptor = interceptor

        return completableResult
    }
}
