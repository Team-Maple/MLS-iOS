import RxSwift

public protocol FetchOutdatedEventsUseCase {
    func execute(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>
}
