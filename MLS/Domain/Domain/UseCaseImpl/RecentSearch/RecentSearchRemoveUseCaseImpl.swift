import DomainInterface
import Foundation

import RxSwift

public class RecentSearchRemoveUseCaseImpl: RecentSearchRemoveUseCase {
    var repository: UserDefaultsRepository
    public init(repository: UserDefaultsRepository) {
        self.repository = repository
    }

    public func remove(keyword: String) -> Completable {
        return repository.removeRecentSearch(keyword: keyword)
    }
}
