import DomainInterface

import RxSwift

public final class FetchDictionaryDetailNpcUseCaseImpl: FetchDictionaryDetailNpcUseCase {
    private let repository: DictionaryDetailAPIRepository

    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int) -> Observable<DictionaryDetailNpcResponse> {
        return repository.fetchNpcDetail(id: id)
    }
}
