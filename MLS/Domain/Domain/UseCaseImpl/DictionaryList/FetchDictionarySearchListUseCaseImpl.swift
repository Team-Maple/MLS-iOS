import DomainInterface

import RxSwift

public final class FetchDictionarySearchListUseCaseImpl: FetchDictionarySearchListUseCase {
    private let repository: DictionaryListAPIRepository

    public init(repository: DictionaryListAPIRepository) {
        self.repository = repository
    }

    public func execute(keyword: String) -> Observable<DictionaryMainResponse> {
        return repository.fetchAllList(keyword: keyword, page: nil)
    }
}
