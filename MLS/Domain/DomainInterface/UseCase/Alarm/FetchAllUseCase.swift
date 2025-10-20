import RxSwift

public protocol FetchAllUseCase {
    func execute(cursor: [Int]?, pageSize: Int) -> Observable<PagedEntity<AllAlarmResponse>>
}
