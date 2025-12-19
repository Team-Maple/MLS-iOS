import RxSwift

public protocol FetchNoticesUseCase {
    func execute(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>
}
