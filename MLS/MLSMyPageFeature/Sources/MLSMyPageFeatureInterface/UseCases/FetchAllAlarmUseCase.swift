import RxSwift

public protocol FetchAllAlarmUseCase {
    func execute(id: Int?, pageSize: Int) -> Observable<PagedEntity<AllAlarmResponse>>
}
