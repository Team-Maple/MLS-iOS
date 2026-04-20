import MLSAuthFeatureInterface

public final class FailingMockTokenRepository: TokenRepository {
    public init() {}

    public func fetchToken(type: TokenType) -> Result<String, Error> {
        .failure(TokenRepositoryError.noValueFound(message: ""))
    }

    public func saveToken(type: TokenType, value: String) -> Result<Void, Error> {
        .failure(TokenRepositoryError.dataConversionError(message: "forced failure"))
    }

    public func deleteToken(type: TokenType) -> Result<Void, Error> {
        .failure(TokenRepositoryError.noValueFound(message: ""))
    }
}
