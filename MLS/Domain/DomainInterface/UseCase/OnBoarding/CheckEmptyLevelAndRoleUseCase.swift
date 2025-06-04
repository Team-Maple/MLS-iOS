import RxSwift

public protocol CheckEmptyLevelAndRoleUseCase {
    func excute(level: Int?, role: String?) -> Observable<Bool>
}
