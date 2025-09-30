import RxSwift

public protocol CheckLoginUseCase {
    func execute() -> Observable<Bool>
}
