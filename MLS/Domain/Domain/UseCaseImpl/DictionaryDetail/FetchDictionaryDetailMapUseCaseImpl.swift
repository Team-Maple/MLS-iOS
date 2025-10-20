import DomainInterface
import RxSwift

public final class FetchDictionaryDetailMapUseCaseImpl: FetchDictionaryDetailMapUseCase {
    private let repository: DictionaryDetailAPIRepository

    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int) -> Observable<DictionaryDetailMapResponse> {
        return repository.fetchMapDetail(id: id)
    }
}
