import RxSwift

public protocol UpdateNickNameUseCase {
    func execute(nickName: String) -> Observable<MyPageResponse>
}
