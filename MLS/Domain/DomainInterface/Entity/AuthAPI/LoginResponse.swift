import Foundation

public struct LoginResponse {
    var isRegister: Bool
    var accessToken: String
    var refreshToken: String
    
    public init(isRegister: Bool, accessToken: String, refreshToken: String) {
        self.isRegister = isRegister
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
