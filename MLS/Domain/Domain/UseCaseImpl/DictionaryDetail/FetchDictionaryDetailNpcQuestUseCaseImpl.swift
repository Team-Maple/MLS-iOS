import DomainInterface
import RxSwift

public final class FetchDictionaryDetailNpcQuestUseCaseImpl: FetchDictionaryDetailNpcQuestUseCase {
    private let repository: DictionaryDetailAPIRepository
    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int, sort: String?) -> Observable<[DictionaryDetailNpcQuestResponse]> {
        return repository.fetchNpcDetailQuest(id: id, sort: sort)
    }
}
