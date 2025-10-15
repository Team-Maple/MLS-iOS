import RxSwift

public protocol FetchPatchNotesUseCase {
    func execute(cursor: [Int]?, pageSize: Int) -> Observable<PagedEntity<AlarmResponse>>
}
