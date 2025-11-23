import DomainInterface

import RxSwift

public final class CreateCollectionListUseCaseImpl: CreateCollectionListUseCase {
    private let repository: CollectionAPIRepository

    public init(repository: CollectionAPIRepository) {
        self.repository = repository
    }

    public func execute(name: String) -> Completable {
        return repository.createCollectionList(name: name)
    }
}
