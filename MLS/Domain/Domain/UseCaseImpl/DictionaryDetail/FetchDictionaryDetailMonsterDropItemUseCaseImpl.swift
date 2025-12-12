import DomainInterface
import RxSwift

public final class FetchDictionaryDetailMonsterDropItemUseCaseImpl: FetchDictionaryDetailMonsterItemsUseCase {
    private let repository: DictionaryDetailAPIRepository
    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int, sort: String?) -> Observable<[DictionaryDetailMonsterDropItemResponse]> {
        return repository.fetchMonsterDetailDropItem(id: id, sort: sort)
    }

}
