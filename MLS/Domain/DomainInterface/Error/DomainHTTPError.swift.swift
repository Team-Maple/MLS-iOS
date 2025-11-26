import Foundation

public enum DomainHTTPError: Error, Equatable {
    case httpStatus(code: Int, message: String?)
    case network
    case decode
    case noData
    case unknown
}
