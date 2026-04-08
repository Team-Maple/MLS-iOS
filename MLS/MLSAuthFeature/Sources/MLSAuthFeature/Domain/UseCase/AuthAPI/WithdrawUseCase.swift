import RxSwift

public protocol WithdrawUseCase {
    func execute() -> Completable
}
