import DomainInterface

import RxSwift

public final class FetchDictionaryDetailItemDropMonsterUseCaseImpl: FetchDictionaryDetailItemDropMonsterUseCase {
    private let repository: DictionaryDetailAPIRepository

    public init(repository: DictionaryDetailAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int, sort: String?) -> Observable<[DictionaryDetailItemDropMonsterResponse]> {
        return repository.fetchItemDetailDropMonster(id: id, sort: sort)
    }
}
