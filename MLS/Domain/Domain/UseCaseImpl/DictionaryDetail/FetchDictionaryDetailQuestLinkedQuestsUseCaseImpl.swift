import DomainInterface

import RxSwift

public final class FetchDictionaryDetailQuestLinkedQuestsUseCaseImpl: FetchDictionaryDetailQuestLinkedQuestsUseCase {
    private let repository: DictionaryDetailAPIRepository
    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int) -> Observable<DictionaryDetailQuestLinkedQuestsResponse> {
        return repository.fetchQuestDetailLinkedQuestsDetail(id: id)
    }
}
