import Foundation

import DomainInterface

public class FetchTokenFromLocalUseCaseImpl: FetchTokenFromLocalUseCase {
    var repository: TokenRepository

    public init(repository: TokenRepository) {
        self.repository = repository
    }

    public func execute(type: TokenType) -> Result<String, Error> {
        return repository.fetchToken(type: type)
    }
}
