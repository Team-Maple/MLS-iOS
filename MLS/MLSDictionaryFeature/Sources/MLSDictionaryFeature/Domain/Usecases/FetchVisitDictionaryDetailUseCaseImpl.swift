import Foundation
import MLSDictionaryFeatureInterface

import RxSwift

public class FetchVisitDictionaryDetailUseCaseImpl: FetchVisitDictionaryDetailUseCase {
    private let repository: DictionaryUserDefaultsRepository
    public init(repository: DictionaryUserDefaultsRepository) {
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
