import RxSwift

public protocol FetchNoticesUseCase {
    func execute(id: Int?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>
}
