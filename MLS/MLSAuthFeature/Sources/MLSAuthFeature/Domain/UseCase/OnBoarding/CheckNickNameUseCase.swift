import RxSwift

public protocol CheckNickNameUseCase {
    func execute(nickName: String) -> Observable<Bool>
}
