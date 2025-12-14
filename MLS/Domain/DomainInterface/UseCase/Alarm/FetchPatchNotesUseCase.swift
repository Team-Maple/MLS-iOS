import RxSwift

public protocol FetchPatchNotesUseCase {
    func execute(cursor: String?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>
}
