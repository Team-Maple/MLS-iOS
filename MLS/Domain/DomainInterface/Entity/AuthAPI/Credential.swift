public protocol Credential: Encodable {
    var token: String { get }
    var providerID: String { get }
}
