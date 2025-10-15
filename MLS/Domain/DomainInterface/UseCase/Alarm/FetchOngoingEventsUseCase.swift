import RxSwift

public protocol FetchOngoingEventsUseCase {
    func execute(cursor: [Int]?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>
}
