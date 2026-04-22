import Foundation

import DomainInterface

import RxSwift

public class FetchPatchNotesUseCaseImpl: FetchPatchNotesUseCase {
    private var repository: AlarmAPIRepository

    public init(repository: AlarmAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>> {
        return repository.fetchPatchNotes(cursor: id, pageSize: pageSize)
    }
}
