import RxSwift

public protocol FetchOutdatedEventsUseCase {
    func execute(cursor: [Int]?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>
}
