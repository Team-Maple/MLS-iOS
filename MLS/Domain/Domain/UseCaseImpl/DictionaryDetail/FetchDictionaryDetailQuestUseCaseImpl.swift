import DomainInterface

import RxSwift

public final class FetchDictionaryDetailQuestUseCaseImpl: FetchDictionaryDetailQuestUseCase {
    private let repository: DictionaryDetailAPIRepository

    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int) -> Observable<DictionaryDetailQuestResponse> {
        return repository.fetchQuestDetail(id: id)
    }
}
