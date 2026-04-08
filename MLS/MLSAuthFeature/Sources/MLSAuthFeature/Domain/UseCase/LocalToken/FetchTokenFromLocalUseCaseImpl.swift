import Foundation



public class FetchTokenFromLocalUseCaseImpl: FetchTokenFromLocalUseCase {
    private let repository: TokenRepository

    public init(repository: TokenRepository) {
        self.repository = repository
    }

    public func execute(type: TokenType) -> Result<String, Error> {
        return repository.fetchToken(type: type)
    }
}
