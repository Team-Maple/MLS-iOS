import DomainInterface
import RxSwift

public final class ToggleBookmarkUseCaseImpl: ToggleBookmarkUseCase {
    private let repository: DictionaryListRepository

    public init(repository: DictionaryListRepository) {
        self.repository = repository
    }

    public func execute(id: String) -> Observable<[DictionaryItem]> {
        return repository.toggleBookmark(id: id)
    }
}
