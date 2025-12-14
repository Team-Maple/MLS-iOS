import RxSwift

public protocol FetchAllAlarmUseCase {
    func execute(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AllAlarmResponse>>
}
