import Foundation

import DomainInterface

import RxSwift

public class TokenInterceptor: Interceptor {
    private let fetchTokenUseCase: FetchTokenFromLocalUseCase

    public init(fetchTokenUseCase: FetchTokenFromLocalUseCase) {
        self.fetchTokenUseCase = fetchTokenUseCase
    }

    public func adapt(_ request: URLRequest) -> URLRequest {
        let accessFetchResult = fetchTokenUseCase.execute(type: .accessToken)
        switch accessFetchResult {
        case .success(let token):
            var adaptedRequest = request
            adaptedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return adaptedRequest
        case .failure:
            return request
        }
    }

    public func retry(data: Data?, response: URLResponse?, error: Error?) -> Bool {
        return false
    }
}
