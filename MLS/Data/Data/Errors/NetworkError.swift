import Foundation

/// 네트워크 레이어에서 사용하는 에러
public enum NetworkError: Error, Equatable {
    case providerDeallocated
    case urlRequest(Error)
    case network(Error)
    case invalidResponse
    case noData
    case decodeError(Error)
    case httpError
    case retryError(Error)
    case statusError(Int, String)
    case retry

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.providerDeallocated, .providerDeallocated),
             (.invalidResponse, .invalidResponse),
             (.noData, .noData),
             (.httpError, .httpError),
             (.retry, .retry):
            return true

        case let (.statusError(code1, msg1), .statusError(code2, msg2)):
            return code1 == code2 && msg1 == msg2

        // 연관된 Error 타입은 Equatable이 아니므로 항상 false로 비교 (혹은 타입 이름 비교 정도만 가능)
        case (.urlRequest, .urlRequest),
             (.network, .network),
             (.decodeError, .decodeError),
             (.retryError, .retryError):
            return false

        default:
            return false
        }
    }
}
