public enum AuthError: Error {
    case unknown(message: String)
    case userNotFound(credential: Credential)
    case tokenExpired
}
