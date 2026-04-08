import Foundation

public protocol TokenRepository {
    func fetchToken(type: TokenType) -> Result<String, Error>
    func saveToken(type: TokenType, value: String) -> Result<Void, Error>
    func deleteToken(type: TokenType) -> Result<Void, Error>
}
