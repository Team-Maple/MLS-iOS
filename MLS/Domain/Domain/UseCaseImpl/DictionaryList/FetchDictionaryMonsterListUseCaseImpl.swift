import DomainInterface

import RxSwift

public final class FetchDictionaryMonsterListUseCaseImpl: FetchDictionaryMonsterListUseCase {

    private let repository: DictionaryListAPIRepository

    public init(repository: DictionaryListAPIRepository) {
        self.repository = repository
    }
    public func execute(type: DictionaryType, query: DictionaryListQuery) -> Observable<DictionaryMainResponse> {
        return repository.fetchMonsterList(keyword: query.keyword, minLevel: query.minLevel, maxLevel: query.maxLevel, page: query.page, size: query.size, sort: query.sort)

    }
}
