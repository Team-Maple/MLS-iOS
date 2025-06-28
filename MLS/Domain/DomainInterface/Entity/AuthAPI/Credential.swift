public protocol Credential: Encodable {
    var token: String? { get }
}
