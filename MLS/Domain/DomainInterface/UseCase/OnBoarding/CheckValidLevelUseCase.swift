import RxSwift

public protocol CheckValidLevelUseCase {
    /// 입력된 레벨의 범위가 0~200에 속하는지 확인
    /// - Parameter level: 입력된 레벨
    /// - Returns:true / false
    func execute(level: Int?) -> Observable<Bool?>
}
