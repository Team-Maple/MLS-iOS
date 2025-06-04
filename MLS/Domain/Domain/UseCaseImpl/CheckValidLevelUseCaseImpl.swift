import DomainInterface

import RxSwift

public class CheckValidLevelUseCaseImpl: CheckValidLevelUseCase {
    public init() {}

    /// 입력된 레벨의 범위가 0~200에 속하는지 확인
    /// - Parameter level: 입력된 레벨
    /// - Returns:true / false
    public func excute(level: Int?) -> Observable<Bool?> {
        guard let level = level else {
            return .just(nil)
        }
        return .just((0 ... 200).contains(level))
    }
}
