import RxSwift
import DomainInterface

public final class ToggleBookmarkUseCaseImpl: ToggleBookmarkUseCase {

    private let repository: DictionaryListRepository

    public init(repository: DictionaryListRepository) {
        self.repository = repository
    }

    public func execute(id: String) -> Observable<Void> {
        return repository.toggleBookmark(id: id)
    }
}
