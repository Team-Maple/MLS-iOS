import RxSwift

public protocol CheckNickNameUseCase {
    /// 닉네임에 비속어가 포함되어 있는지 판별
    /// - Parameters:
    ///   - nickName: 현재 입력된 닉네임
    /// - Returns: true / false
    func execute(nickName: String) -> Observable<Bool>
}
