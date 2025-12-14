import DomainInterface
import Foundation

import RxSwift

public class RecentSearchAddUseCaseImpl: RecentSearchAddUseCase {
    var repository: UserDefaultsRepository

    public init(repository: UserDefaultsRepository) {
        self.repository = repository
    }

    public func add(keyword: String) -> Completable {
        guard !keyword.isEmpty else { return .empty() }
        return repository.addRecentSearch(keyword: keyword)
    }
}
