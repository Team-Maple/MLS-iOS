import Foundation

import DomainInterface

import RxSwift

public class FetchPatchNotesUseCaseImpl: FetchPatchNotesUseCase {
    private var repository: AlarmAPIRepository

    public init(repository: AlarmAPIRepository) {
        self.repository = repository
    }

    public func execute(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>> {
        return repository.fetchPatchNotes(cursor: cursor, pageSize: pageSize)
    }
}
