import Foundation

import DomainInterface

import RxSwift

public class FetchNoticesUseCaseImpl: FetchNoticesUseCase {
    private var repository: AlarmAPIRepository

    public init(repository: AlarmAPIRepository) {
        self.repository = repository
    }

    public func execute(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>> {
        return repository.fetchNotices(cursor: cursor, pageSize: pageSize)
    }
}
