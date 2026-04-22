import Foundation
import Security

public enum TokenRepositoryError: Error {
    case noValueFound(message: String)
    case unhandledError(status: OSStatus)
    case dataConversionError(message: String)
}

public enum TokenType: String {
    case accessToken
    case refreshToken
    case fcmToken
}
