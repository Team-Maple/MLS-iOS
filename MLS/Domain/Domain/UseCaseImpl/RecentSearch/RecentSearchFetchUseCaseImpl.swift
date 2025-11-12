import DomainInterface

import RxSwift

public final class RecentSearchFetchUseCaseImpl: RecentSearchFetchUseCase {
    private let repository: UserDefaultsRepository

    public init(repository: UserDefaultsRepository) {
        self.repository = repository
    }

    public func fetch() -> Observable<[String]> {
        return repository.fetchRecentSearch()
    }
}
