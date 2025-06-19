import DomainInterface
import RxSwift

public final class FetchDictionaryItemsUseCaseImpl: FetchDictionaryItemsUseCase {

    private let repository: DictionaryListRepository

    public init(repository: DictionaryListRepository) {
        self.repository = repository
    }

    public func execute(type: DictionaryType) -> Observable<[DictionaryItem]> {
        return repository.observeItems(type: type)
    }
}
