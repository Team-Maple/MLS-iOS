import RxSwift

public protocol FetchOngoingEventsUseCase {
    func execute(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>
}
