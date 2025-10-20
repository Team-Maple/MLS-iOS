import DomainInterface
import RxSwift

public final class FetchDictionaryDetailNpcMapUseCaseImpl: FetchDictionaryDetailNpcMapUseCase {
    private let repository: DictionaryDetailAPIRepository
    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }
    public func execute(id: Int) -> Observable<[DictionaryDetailMonsterMapResponse]> {
        return repository.fetchNpcDetailMap(id: id)
    }
}
