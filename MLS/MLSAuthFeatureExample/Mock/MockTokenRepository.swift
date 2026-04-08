import MLSAuthFeature

final class MockTokenRepository: TokenRepository {
    private var storage: [String: String] = [:]

    func fetchToken(type: TokenType) -> Result<String, Error> {
        if let value = storage[type.rawValue] {
            return .success(value)
        }
        return .failure(TokenRepositoryError.noValueFound(message: "\(type.rawValue) not found"))
    }

    func saveToken(type: TokenType, value: String) -> Result<Void, Error> {
        storage[type.rawValue] = value
        return .success(())
    }

    func deleteToken(type: TokenType) -> Result<Void, Error> {
        storage[type.rawValue] = nil
        return .success(())
    }
}
