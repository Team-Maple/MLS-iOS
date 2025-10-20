import DomainInterface

import RxSwift

public final class FetchDictionaryDetailItemUseCaseImpl: FetchDictionaryDetailItemUseCase {
    private let repository: DictionaryDetailAPIRepository

    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int) -> Observable<DictionaryDetailItemResponse> {
        return repository.fetchItemDetail(id: id)
    }
}
