import Foundation

public struct LoginResponse {
    public var isRegister: Bool
    public var accessToken: String
    public var refreshToken: String

    public init(isRegister: Bool, accessToken: String, refreshToken: String) {
        self.isRegister = isRegister
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
