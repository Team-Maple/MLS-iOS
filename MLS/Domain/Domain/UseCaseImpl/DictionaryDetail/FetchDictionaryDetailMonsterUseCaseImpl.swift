import DomainInterface

import RxSwift

public final class FetchDictionaryDetailMonsterUseCaseImpl: FetchDictionaryDetailMonsterUseCase {
    private let repository: DictionaryDetailAPIRepository

    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int) -> Observable<DictionaryDetailMonsterResponse> {
        return repository.fetchMonsterDetail(id: id)
    }
}
