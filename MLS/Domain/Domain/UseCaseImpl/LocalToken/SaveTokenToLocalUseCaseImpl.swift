import Foundation

import DomainInterface

public class SaveTokenToLocalUseCaseImpl: SaveTokenToLocalUseCase {
    var repository: TokenRepository

    public init(repository: TokenRepository) {
        self.repository = repository
    }

    public func execute(type: TokenType, value: String) -> Result<Void, Error> {
        return repository.saveToken(type: type, value: value)
    }
}
