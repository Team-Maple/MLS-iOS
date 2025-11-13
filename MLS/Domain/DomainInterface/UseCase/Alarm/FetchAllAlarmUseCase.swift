import RxSwift

public protocol FetchAllAlarmUseCase {
    func execute(cursor: [Int]?, pageSize: Int) -> Observable<PagedEntity<AllAlarmResponse>>
}
