import Foundation

import DomainInterface

import RxSwift

public class FetchOutdatedEventsUseCaseImpl: FetchOutdatedEventsUseCase {
    private var repository: AlarmAPIRepository

    public init(repository: AlarmAPIRepository) {
        self.repository = repository
    }

    public func execute(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>> {
        return repository.fetchOutdatedEvents(cursor: cursor, pageSize: pageSize)
    }
}
