import Foundation

public struct SignUpResponse {
    var accessToken: String
    var refreshToken: String
    
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
