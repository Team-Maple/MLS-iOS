import MLSAuthFeature
import MLSAuthFeatureInterface

public final class MockTokenRepository: TokenRepository {
    private var storage: [String: String] = [:]

    public init() {}

    public func fetchToken(type: TokenType) -> Result<String, Error> {
        if let value = storage[type.rawValue] {
            return .success(value)
        }
        return .failure(TokenRepositoryError.noValueFound(message: "\(type.rawValue) not found"))
    }

    public func saveToken(type: TokenType, value: String) -> Result<Void, Error> {
        storage[type.rawValue] = value
        return .success(())
    }

    public func deleteToken(type: TokenType) -> Result<Void, Error> {
        storage[type.rawValue] = nil
        return .success(())
    }
}
