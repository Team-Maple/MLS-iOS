import DomainInterface

import RxSwift

public final class FetchDictionaryMapListUseCaseImpl: FetchDictionaryMapListUseCase {

    private let repository: DictionaryListAPIRepository

    public init(repository: DictionaryListAPIRepository) {
        self.repository = repository
    }

    public func execute(keyword: String, page: Int, size: Int, sort: String?) -> Observable<DictionaryMainResponse> {
        return repository.fetchMapList(keyword: keyword, page: page, size: size, sort: sort)
    }
}
