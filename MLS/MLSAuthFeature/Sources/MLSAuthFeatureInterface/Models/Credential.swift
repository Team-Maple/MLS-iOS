public protocol Credential {
    var token: String { get }
    var providerID: String { get }
}
