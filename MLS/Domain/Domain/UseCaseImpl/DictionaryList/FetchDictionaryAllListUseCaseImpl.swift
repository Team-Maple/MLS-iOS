import DomainInterface

import RxSwift

public final class FetchDictionaryAllListUseCaseImpl: FetchDictionaryAllListUseCase {

    private let repository: DictionaryListAPIRepository

    public init(repository: DictionaryListAPIRepository) {
        self.repository = repository
    }

    public func execute(keyword: String?, page: Int?) -> Observable<DictionaryMainResponse> {
        return repository.fetchAllList(keyword: keyword, page: page)
    }
}
