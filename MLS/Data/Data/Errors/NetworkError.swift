import Foundation

/// 네트워크 레이어에서 사용하는 에러
public enum NetworkError: Error {
    case providerDeallocated
    case urlRequest(Error)
    case network(Error)
    case invalidResponse
    case noData
    case decodeError(Error)
    case httpError
    case retryError(Error)
    case statusError(Int, String)
}
