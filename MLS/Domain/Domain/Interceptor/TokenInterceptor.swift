import Foundation

import DomainInterface

import RxSwift

public class TokenInterceptor: Interceptor {
    private let fetchTokenUseCase: FetchTokenFromLocalUseCase
    public init(fetchTokenUseCase: FetchTokenFromLocalUseCase) {
        self.fetchTokenUseCase = fetchTokenUseCase
    }

    public func adapt(_ request: URLRequest) -> URLRequest {
        var adaptedRequest = request
        adaptedRequest.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0MjU2MDIyNDk4IiwiaWF0IjoxNzYyMzUyODE0LCJleHAiOjIwNzc3MTI4MTR9.6pMpn6kF7zPbVW1U4Lbo1NbhlYc2IwRcDChAERoIo14", forHTTPHeaderField: "Authorization")
        return adaptedRequest
    }

    public func retry(data: Data?, response: URLResponse?, error: Error?) -> Bool {
        return false
    }
}
