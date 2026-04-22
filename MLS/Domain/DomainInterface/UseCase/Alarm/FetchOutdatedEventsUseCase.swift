import RxSwift

public protocol FetchOutdatedEventsUseCase {
    func execute(id: Int?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>
}
