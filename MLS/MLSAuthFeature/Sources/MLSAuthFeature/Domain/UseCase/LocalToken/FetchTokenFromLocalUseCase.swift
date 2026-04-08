import Foundation

public protocol FetchTokenFromLocalUseCase {
    func execute(type: TokenType) -> Result<String, Error>
}
