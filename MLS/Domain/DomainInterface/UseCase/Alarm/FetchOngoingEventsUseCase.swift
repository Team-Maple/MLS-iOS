import RxSwift

public protocol FetchOngoingEventsUseCase {
    func execute(id: Int?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>
}
