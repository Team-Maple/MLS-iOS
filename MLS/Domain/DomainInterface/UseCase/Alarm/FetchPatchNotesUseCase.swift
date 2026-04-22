import RxSwift

public protocol FetchPatchNotesUseCase {
    func execute(id: Int?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>
}
