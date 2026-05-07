import Foundation

import MLSCore

public final class MockInterceptor: Interceptor {

    public init() {}

    public var adaptCalled = false
    public var retryCalled = false

    public var receivedRequest: URLRequest?
    public var receivedData: Data?
    public var receivedResponse: URLResponse?
    public var receivedError: Error?

    public var adaptedRequest: URLRequest?
    public var retryResult: Bool = false

    public func adapt(_ request: URLRequest) -> URLRequest {
        adaptCalled = true
        receivedRequest = request

        return adaptedRequest ?? request
    }

    public func retry(
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) -> Bool {
        retryCalled = true
        receivedData = data
        receivedResponse = response
        receivedError = error

        return retryResult
    }
}
