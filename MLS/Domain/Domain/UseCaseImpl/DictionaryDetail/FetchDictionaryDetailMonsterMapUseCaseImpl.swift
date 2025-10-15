import DomainInterface
import RxSwift

public final class FetchDictionaryDetailMonsterMapUseCaseImpl: FetchDictionaryDetailMonsterMapUseCase {
    private let repository: DictionaryDetailAPIRepository
    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }
    public func execute(id: Int) -> Observable<[DictionaryDetailMonsterMapResponse]> {
        return repository.fetchMonsterDetailMap(id: id)
    }
}
