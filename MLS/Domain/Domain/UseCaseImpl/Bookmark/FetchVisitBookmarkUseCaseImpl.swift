import DomainInterface
import Foundation

import RxSwift

public class FetchVisitBookmarkUseCaseImpl: FetchVisitBookmarkUseCase {
    var repository: UserDefaultsRepository
    public init(repository: UserDefaultsRepository) {
        self.repository = repository
    }

    public func execute() -> Observable<Bool> {
        return repository.fetchBookmark()
            .flatMap { hasVisited -> Observable<Bool> in
                if hasVisited {
                    return .just(true)
                } else {
                    return self.repository.saveBookmark()
                        .andThen(.just(false))
                }
            }
    }
}
