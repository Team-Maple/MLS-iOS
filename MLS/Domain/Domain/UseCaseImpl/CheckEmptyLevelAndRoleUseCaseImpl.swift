import DomainInterface

import RxSwift

public class CheckEmptyLevelAndRoleUseCaseImpl: CheckEmptyLevelAndRoleUseCase {
    public init() {}

    /// 레벨의 범위가 0~200에 속하는지 + 직업이 유효한 값인지 확인
    /// - Parameters:
    ///   - level: 현재 입력된 레벨
    ///   - role: 현재 입력된 직업
    /// - Returns: true / false
    public func excute(level: Int?, role: String?) -> Observable<Bool> {
        let isValidLevel = level.map { (1 ... 200).contains($0) } ?? false
        let isValidRole = role != nil && role != ""
        return .just(isValidLevel && isValidRole)
    }
}
