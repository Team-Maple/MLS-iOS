import DomainInterface
import RxSwift

public final class FetchDictionaryDetailMapNpcUseCaseImpl: FetchDictionaryDetailMapNpcUseCase {
    private let repository: DictionaryDetailAPIRepository
    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int) -> Observable<[DictionaryDetailMapNpcResponse]> {
        return repository.fetchMapDetailNpc(id: id)
    }
}
