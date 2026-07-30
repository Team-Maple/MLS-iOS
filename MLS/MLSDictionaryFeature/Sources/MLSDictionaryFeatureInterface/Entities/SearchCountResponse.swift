public struct SearchCountResponse: Decodable {
    public let count: Int?

    public init(count: Int?) {
        self.count = count
    }
}
