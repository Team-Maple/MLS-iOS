import RxSwift

public protocol CheckEmptyLevelAndRoleUseCase {
    /// 레벨의 범위가 0~200에 속하는지 + 직업이 유효한 값인지 확인
    /// - Parameters:
    ///   - level: 현재 입력된 레벨
    ///   - job: 현재 입력된 직업
    /// - Returns: true / false
    func execute(level: Int?, job: String?) -> Observable<Bool>
}
