import Foundation

import DomainInterface

import RxSwift

public class FetchAllUseCaseImpl: FetchAllUseCase {
    private var repository: AlarmAPIRepository

    public init(repository: AlarmAPIRepository) {
        self.repository = repository
    }

    public func execute(cursor: [Int]?, pageSize: Int) -> Observable<PagedEntity<AllAlarmResponse>> {
        return repository.fetchAll(cursor: cursor, pageSize: pageSize)
    }
}
