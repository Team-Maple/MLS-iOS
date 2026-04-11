import MLSAuthFeatureInterface

public extension LoginResponse {
    static let registered = LoginResponse(isRegister: true, accessToken: "", refreshToken: "")
    static let unregistered = LoginResponse(isRegister: false, accessToken: "", refreshToken: "")
}
