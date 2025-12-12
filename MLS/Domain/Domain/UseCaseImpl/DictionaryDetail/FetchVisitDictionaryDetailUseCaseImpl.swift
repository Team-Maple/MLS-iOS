import DomainInterface
import Foundation

import RxSwift

public class FetchVisitDictionaryDetailUseCaseImpl: FetchVisitDictionaryDetailUseCase {
    var repository: UserDefaultsRepository
    public init(repository: UserDefaultsRepository) {
        self.repository = repository
    }

    public func execute() -> Observable<Bool> {
        return repository.fetchDictionaryDetail()
            .flatMap { hasVisited -> Observable<Bool> in
                if hasVisited {
                    return .just(true)
                } else {
                    return self.repository.saveDictionaryDetail()
                        .andThen(.just(false))
                }
            }
    }
}
