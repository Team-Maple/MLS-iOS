import DomainInterface
import RxSwift

public final class FetchDictionaryDetailMapSpawnMonsterUseCaseImpl: FetchDictionaryDetailMapSpawnMonsterUseCase {
    private let repository: DictionaryDetailAPIRepository
    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int, sort: String?) -> Observable<[DictionaryDetailMapSpawnMonsterResponse]> {
        return repository.fetchMapDetailSpawnMonster(id: id, sort: sort)
    }
}
