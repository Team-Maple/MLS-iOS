import RxSwift

public protocol CheckEmptyLevelAndRoleUseCase {
    func execute(level: Int?, job: String?) -> Observable<Bool>
}
