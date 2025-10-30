public struct SearchCountResponse: Codable {
    public let count: Int?
    
    public init(count: Int?) {
        self.count = count
    }
}
