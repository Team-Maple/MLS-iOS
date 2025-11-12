import DomainInterface

import RxSwift

public final class FetchDictionaryListCountUseCaseImpl: FetchDictionaryListCountUseCase {
    private let repository: DictionaryListAPIRepository

    public init(repository: DictionaryListAPIRepository) {
        self.repository = repository
    }

    public func execute(type: String, keyword: String?) -> Observable<SearchCountResponse> {
        return repository.fetchSearchListCount(type: type, keyword: keyword)
    }
}
