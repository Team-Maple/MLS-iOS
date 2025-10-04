import RxSwift

public protocol FetchNoticesUseCase {
    func execute(cursor: [Int]?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>
}
