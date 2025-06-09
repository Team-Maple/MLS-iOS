import Foundation

import DomainInterface

public class DeleteTokenFromLocalUseCaseImpl: DeleteTokenFromLocalUseCase {
    var repository: TokenRepository

    public init(repository: TokenRepository) {
        self.repository = repository
    }

    public func execute(type: TokenType) -> Result<Void, Error> {
        return repository.deleteToken(type: type)
    }
}
