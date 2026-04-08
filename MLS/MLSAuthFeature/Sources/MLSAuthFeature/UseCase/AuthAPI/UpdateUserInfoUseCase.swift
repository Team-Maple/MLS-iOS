import RxSwift

public protocol UpdateUserInfoUseCase {
    func execute(level: Int, selectedJobID: Int) -> Completable
}
