import Foundation

import DomainInterface

import RxSwift

public class FetchAllAlarmUseCaseImpl: FetchAllAlarmUseCase {
    private var repository: AlarmAPIRepository

    public init(repository: AlarmAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int?, pageSize: Int) -> Observable<PagedEntity<AllAlarmResponse>> {
        return repository.fetchAll(cursor: id, pageSize: pageSize)
    }
}
