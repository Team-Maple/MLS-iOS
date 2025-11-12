import DomainInterface

import RxSwift

public final class FetchDictionaryItemListUseCaseImpl: FetchDictionaryItemListUseCase {

    private let repository: DictionaryListAPIRepository

    public init(repository: DictionaryListAPIRepository) {
        self.repository = repository
    }

    public func execute(keyword: String?, jobId: [Int]?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, page: Int?, size: Int?, sort: String?) -> Observable<DictionaryMainResponse> {
        return repository.fetchItemList(keyword: keyword, jobId: jobId, minLevel: minLevel, maxLevel: maxLevel, categoryIds: categoryIds, page: page, size: size, sort: sort)
    }
}
