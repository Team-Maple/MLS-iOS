import DomainInterface
import RxSwift

public final class FetchDictionaryDetailMapSpawnMonsterUseCaseImpl: FetchDictionaryDetailMapSpawnMonsterUseCase {
    private let repository: DictionaryDetailAPIRepository
    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }
    
    public func execute(id: Int) -> Observable<[DictionaryDetailMapSpawnMonsterResponse]> {
        return repository.fetchMapDetailSpawnMonster(id: id)
    }
}
